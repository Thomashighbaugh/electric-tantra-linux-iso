#!/usr/bin/env bash

## Pre-build script for archcraft OS.

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')" GREEN="$(printf '\033[32m')" ORANGE="$(printf '\033[33m')" BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')" CYAN="$(printf '\033[36m')" WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')" GREENBG="$(printf '\033[42m')" ORANGEBG="$(printf '\033[43m')" BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')" CYANBG="$(printf '\033[46m')" WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Directories
DIR="$(pwd)"

## Banner
banner() {
	clear
	cat <<-_EOF_

		    ${RED}┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
		    │  ${CYAN}    dBBBP  dBP    dBBBP  dBBBP dBBBBBBP dBBBBBb    dBP dBBBP     dBBBBBBP dBBBBBb     dBBBBb dBBBBBBP dBBBBBb dBBBBBb  ${RED}│
		    │  ${CYAN}                                            dBP                                BB        dBP              dBP      BB  ${RED}│
		    │  ${CYAN}  dBBP   dBP    dBBP   dBP      dBP     dBBBBK   dBP dBP          dBP      dBP BB   dBP dBP   dBP     dBBBBK   dBP BB  ${RED}│
		    │  ${CYAN} dBP    dBP    dBP    dBP      dBP     dBP  BB  dBP dBP          dBP      dBP  BB  dBP dBP   dBP     dBP  BB  dBP  BB  ${RED}│
		    │  ${CYAN}dBBBBP dBBBBP dBBBBP dBBBBP   dBP     dBP  dB' dBP dBBBBP       dBP      dBBBBBBB dBP dBP   dBP     dBP  dB' dBBBBBBB  ${RED}│
		    └─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
	_EOF_
}

## Reset terminal colors
reset_color() {
	tput sgr0 # reset attributes
	tput op   # reset color
	return
}

## Script Termination
exit_on_signal_SIGINT() {
	{
		printf ${RED}"\n\n%s\n" "[*] Script interrupted." 2>&1
		echo
		reset_color
	}
	exit 0
}

exit_on_signal_SIGTERM() {
	{
		printf ${RED}"\n\n%s\n" "[*] Script terminated." 2>&1
		echo
		reset_color
	}
	exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Prerequisite
prerequisite() {
	{
		echo
		echo ${ORANGE}"[*] ${BLUE}Installing Dependencies... ${CYAN}"
		echo
	}
	if [[ -f /usr/bin/mkarchiso ]]; then
		{ echo ${ORANGE}"[*] ${GREEN}Dependencies are already Installed!"; }
	else
		sudo pacman -Sy archiso --noconfirm
		(type -p mkarchiso &>/dev/null) && {
			echo
			echo "${ORANGE}[*] ${GREEN}Dependencies are succesfully installed!"
		} || {
			echo
			echo "${BLUE}[!] ${RED}Error Occured, failed to install dependencies."
			echo
			reset_color
			exit 1
		}
	fi
	{
		echo
		echo ${ORANGE}"[*] ${BLUE}Modifying /usr/bin/mkarchiso - ${CYAN}"
		echo
	}
	sudo cp /usr/bin/mkarchiso{,.bak} && sudo sed -i -e 's/-c -G -M/-i -c -G -M/g' /usr/bin/mkarchiso
	sudo sed -i -e 's/archiso-x86_64/archcraftiso-x86_64/g' /usr/bin/mkarchiso
	{
		echo
		echo -e ${ORANGE}"[*] ${GREEN}Succesfully Modified."
		echo
	}
}

## Changing ownership to root to avoid false permissions error
set_mod() {
	echo ${ORANGE}"[*] ${BLUE}Setting up correct permissions..."
	sudo chown -R root:root $DIR/iso/
	{
		echo
		echo ${ORANGE}"[*] ${GREEN}Setup Completed, now begins the ISO building phase."
		echo
	}
}

build-iso() {
	clear
	echo
	echo ${ORANGE}"[*] ${GREEN}The ISO is now being built in /tmp, please wait!."
	echo
	sudo mkarchiso -v -w /tmp/mkarchiso ./iso

	echo
	echo ${ORANGE}"[*] ${GREEN}ISO building has finished... finally"
	echo

}

clean() {

	echo
	echo ${ORANGE}"[*] ${GREEN} Cleaning up the system!"
	echo

	sudo rm -rf /tmp/mkarchiso
}

## Main
banner
prerequisite
set_mod
exit 0
