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

info "Installing rbenv & ruby ..."
cd
git clone 'https://github.com/rbenv/rbenv.git'      "${HOME}/.rbenv"
git clone 'https://github.com/rbenv/ruby-build.git' "${HOME}/.rbenv/plugins/ruby-build"

cat << 'EOF' > "${HOME}/.bash_post"
export PATH="${HOME}/.rbenv/bin:${PATH}"
eval "$(rbenv init -)"
export PATH="${HOME}/.rbenv/plugins/ruby-build/bin:${PATH}"
EOF

source "${HOME}/.bash_post"

rbenv install "${RUBY_VERSION}"
rbenv global  "${RUBY_VERSION}"

gem install bundler
rbenv rehash

ruby -v

info "Installing rails ..."
gem install rails -v "${RAILS_VERSION}"
rails -v

info "Installing node ..."
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

info "Installing Heroky toolbelt ..."
sudo wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# implementation here
info "Provisioning done."

