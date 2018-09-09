#!/bin/bash

# ============================================================================
# Log auxiliary functions
# ============================================================================
escape="\033["

# Colors
green="32"
yellow="33"
red="31"

function info() {
	local message="${1}"
	_log "INFO" "${green}" "${message}"
}

function warn() {
	local message="${1}"
	_log "WARN" "${yellow}" "${message}"
}

function error() {
	local message="${1}"
	_log "ERROR" "${red}" "${message}"
}

# USAGE: log "info" "message"
function log() {
	local level="${1}"
	local message="${2}"

	${level} "${message}"

}

# USAGE: _log "info" "32" "message"
function _log() {
	local level="${1}"
	local color=""
	local reset=""
	if [ -t 2 ]; then
		color="${escape}0;${2}m"
		reset="${escape}0m"
	fi
	local message="${3}"

	>&2 echo -e "${color}[${level}]${reset}\t${message}"

}

# ============================================================================
# Main
# ============================================================================
RUBY_VERSION='2.5.1'
RAILS_VERSION='5.2.0'

info "Updating package db and installing git & vim ..."
sudo apt-get update
sudo apt-get install -y git vim

info "Installing dotfiles ..."
cd
git clone 'https://github.com/jpducassou/dotfiles'
rm "${HOME}/.profile"
rm "${HOME}/.bashrc"
cd dotfiles
./install.sh

info "Installing basic packages ..."
cd
cat dotfiles/packages/01-basic.lst | grep -vh '#' | xargs sudo apt-get install -y

info "Installing devel packages ..."
cat dotfiles/packages/03-devel.lst | grep -vh '#' | xargs sudo apt-get install -y

info "Installing ruby dependencies ..."
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev

info "Installing SQLite ..."
sudo apt-get install -y libsqlite3-dev sqlite3

info "Installing PostgreSQL ..."
sudo apt-get install postgresql

info "Installing PostgreSQL lib ..."
sudo apt-get install -y libpq-dev

# ============================================================================
# Ruby && Rails
# ============================================================================
info "Installing rbenv & ruby ..."
cd
git clone 'https://github.com/rbenv/rbenv.git'      "${HOME}/.rbenv"
git clone 'https://github.com/rbenv/ruby-build.git' "${HOME}/.rbenv/plugins/ruby-build"

source "${HOME}/.bashrc"

rbenv install "${RUBY_VERSION}"
rbenv global  "${RUBY_VERSION}"

gem install bundler
rbenv rehash

ruby -v

info "Installing rails ..."
gem install rails -v "${RAILS_VERSION}"
rails -v

# ============================================================================
# Nvm && Node && yarn
# ============================================================================
info "Installing nvm ..."
export NVM_DIR="${HOME}/.nvm"
git clone 'https://github.com/creationix/nvm.git' "${NVM_DIR}"
pushd "${NVM_DIR}"
git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
popd

. "${NVM_DIR}/nvm.sh"

info "Installing node ..."
nvm install 8.11.4
nvm use 8.11.4
nvm alias default v8.11.4
npm install -g yarn

node -v
yarn -v

# ============================================================================
# Heroku
# ============================================================================
info "Installing Heroky toolbelt ..."
sudo wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# ============================================================================
info "Provisioning done."

