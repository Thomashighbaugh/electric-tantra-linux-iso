#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

#user modifications
groupadd liveuser
groupadd autologin
usermod -g liveuser -d /home/liveuser -m -s /bin/zsh -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel,autologin" liveuser
echo "liveuser ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
usermod -s /usr/bin/zsh root
chmod 700 /root

# Setup keyrings
pacman-key --init
pacman-key --populate

# Attempt to work around build failure on debian hosts.
mkdir -p /build/archiso/work/x86_64/airootfs/run/shm
mkdir -p /build/archiso/work/x86_64/airootfs/var/run/shm
mkdir -p /run/shm
mkdir -p /var/run/shm

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# Re-Branding
sed -i.bak 's/Arch Linux/Electric Tantra Linux/g' /usr/lib/os-release
sed -i.bak 's/arch/electrictantra/g' /usr/lib/os-release
sed -i.bak 's#www.archlinux.org#github.com/Thomashighbaugh/electric-tantra-linux-iso#g' /usr/lib/os-release
sed -i.bak 's#bbs.archlinux.org#github.com/Thomashighbaugh/electric-tantra-linux-iso#g' /usr/lib/os-release
sed -i.bak 's#bugs.archlinux.org#github.com/Thomashighbaugh/electric-tantra-linux-iso#g' /usr/lib/os-release

## Disto Info
cat >"/etc/os-release" <<-EOL
	NAME="ElectricTantra"
	PRETTY_NAME="Electric Tantra Linux"
	ID=arch
	BUILD_ID=rolling
	ANSI_COLOR="38;13;39;126;198"
	HOME_URL="https://github.com/Thomashighbaugh/electric-tantra-iso"
	LOGO=electrictantra
EOL

cat >"/etc/issue" <<-EOL
	ElectricTantra \r (\l)
EOL

# Service Activation
systemctl enable pacman-init.service choose-mirror.service

# This throws out warnings but still works.
systemctl enable lightdm
systemctl enable graphical.target

# Enable network manager
systemctl enable NetworkManager
systemctl enable wpa_supplicant.service

# Enable graphical boot
systemctl set-default graphical.target

## Mods
rm -rf /usr/share/xsessions/openbox-kde.desktop /usr/share/xsessions/i3-with-shmlog.desktop
