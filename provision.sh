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
apt-get update
apt-get install -y git vim

info "Installing dotfiles ..."
git clone 'https://github.com/jpducassou/dotfiles'
cd dotfiles
./install.sh

# implementation here
info "Provisioning done."

