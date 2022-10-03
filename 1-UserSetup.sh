cd ~/
git clone https://aur.archlinux.org/yay.git
makepkg -csi --noconfirm
cd ..
rm -rf yay

PKGS=(
    'spotify'
    'lutris'
    'rtl88x2bu-dkms-git'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    yay -S "$PKG" --needed --noconfirm
done