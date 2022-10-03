#!/usr/bin/env bash

if [ $EUID -ne 0 ]
	then
		echo "This program must run as root to function." 
		exit 1
fi

PKGS=(
    # TERMINAL UTILITIES --------------------------------------------------

    'bash-completion'       # Tab completion for Bash
    'curl'                  # Remote content retrieval
    'feh'                   # Terminal-based image viewer/manipulator
    'gnome-keyring'         # System password storage
    'gtop'                  # System monitoring via terminal
    'htop'                  # Process viewer
    'neofetch'              # Shows system info when you launch terminal
    'numlockx'              # Turns on numlock in X11
    'openssh'               # SSH connectivity tools
    'rsync'                 # Remote file sync utility
    'speedtest-cli'         # Internet speed via terminal
    'unrar'                 # RAR compression program
    'unzip'                 # Zip compression program
    'wget'                  # Remote content retrieval
    'zip'                   # Zip compression program
    

    # DISK UTILITIES ------------------------------------------------------

    'exfat-utils'           # Mount exFat drives
    'gparted'               # Disk utility
    'ntfs-3g'               # Open source implementation of NTFS file system
    'parted'                # Disk utility
    'timeshift'

    # DEVELOPMENT ---------------------------------------------------------

    'git'                   # Version control system
    'nodejs'                # Javascript runtime environment
    'npm'                   # Node package manager

    # WEB TOOLS -----------------------------------------------------------

    'firefox'               # Web browser
    'filezilla'             # FTP Client
    'flashplugin'           # Flash

    # COMMUNICATIONS ------------------------------------------------------

    'discord'               # Multi format chat

    # MEDIA ---------------------------------------------------------------

    'vlc'                   # Video player

    # GRAPHICS AND DESIGN -------------------------------------------------

    'gimp'                  # GNU Image Manipulation Program
    'inkscape'              # Vector image creation app
    'blender'               # 3D MODELLING PROGRAM

    # PRODUCTIVITY --------------------------------------------------------

    'hunspell'              # Spellcheck libraries
    'hunspell-en'           # English spellcheck library
    'libreoffice-fresh'     # Libre office with extra features
    'xpdf'                  # PDF viewer

    # VIRTUALIZATION ------------------------------------------------------

    'libvirt'
    'libvirt-glib'
    'libvirt-python'
    'virt-install'
    'virt-manager'
    'qemu'
    'qemu-arch-extra'
    'ovmf'
    'vde2'
    'ebtables'
    'dnsmasq'
    'bridge-utils'
    'openbsd-netcat'
    'iptables'
    'swtpm'

    # PRINTER -----------------------------------------------------------
    
    'cups'                  # Open source printer drivers
    'cups-pdf'              # PDF support for cups
    'ghostscript'           # PostScript interpreter
    'gsfonts'               # Adobe Postscript replacement fonts
    'hplip'                 # HP Drivers
    'system-config-printer' # Printer setup  utility    

    # BLUETOOTH ----------------------------------------------------------

    'bluez'                 # Daemons for the bluetooth protocol stack
    'bluez-utils'           # Bluetooth development and debugging utilities
    'bluez-firmware'        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
    'blueberry'             # Bluetooth configuration tool
    'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio
    'bluez-libs'

    # GAMING

    'steam'

)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --needed
done

## Setup virtualization

systemctl enable libvirtd --now

mv /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.old
gpasswd -M lucas kvm
gpasswd -M lucas libvirt
mv libvirtd.conf /etc/libvirt
echo "mv /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.old"
mv /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.old
mv qemu.conf /etc/libvirt
systemctl restart libvirtd

## Enable iommu in grub

GRUB=`cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT" | rev | cut -c 2- | rev`
#adds amd_iommu=on and iommu=pt to the grub config
GRUB+=" intel_iommu=on iommu=pt\""
sed -i -e "s|^GRUB_CMDLINE_LINUX_DEFAULT.*|${GRUB}|" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

