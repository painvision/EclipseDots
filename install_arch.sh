#!/usr/bin/env bash
set -e

confirm_action() {
    echo ""
    echo ""
    read -p "[!] Make sure to have hypr/kitty configuration backups. Are you sure you want to proceed installation? [Y/n]: " choice
    case "$choice" in
        y|Y )
            echo "[+] Continuing"
            ;;
        n|N )
            echo "[-] Cancelled"
            exit 1
            ;;
        * )
            echo "Invalid input. Please enter 'Y' or 'n'."
            confirm_action
            ;;
    esac
}

REPO_URL="https://github.com/painvision/EclipseDots"
INSTALL_DIR="$HOME/installed_eclipsedots"
SOURCE_CONFIG="$INSTALL_DIR/dots/config"
TARGET_CONFIG="$HOME/.config"

SOURCE_FASTFETCH="$INSTALL_DIR/dots/fastfetch"
TARGET_FASTFETCH="$HOME/.local/share/fastfetch"

GREEN="\e[32m"; YELLOW="\e[33m"; RED="\e[31m"; RESET="\e[0m"
log() { echo -e "${GREEN}[+]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
err() { echo -e "${RED}[-]${RESET} $1"; }

log "=== EclipseDots Installer ==="

if ! command -v yay &>/dev/null; then
    warn "yay not found, installing..."

    sudo pacman -S --needed --noconfirm base-devel git go

    if [ ! -d "$HOME/yay" ]; then
        git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    fi

    cd "$HOME/yay"
    makepkg -si --noconfirm
    cd -
else
    log "yay already installed."
fi

yay -S --needed --noconfirm \
    hyprland kitty nemo firefox btop ydotool quickshell matugen \
    gpu-screen-recorder brightnessctl ddcutil cliphist cava \
    wlsunset xdg-desktop-portal python3 evolution-data-server \
    polkit-kde-agent cmake meson cpio pkg-config git gcc matugen noctalia-shell

confirm_action

if [ ! -d "$INSTALL_DIR" ]; then
    log "Cloning repo into $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR"
else
    log "Updating repo..."
    git -C "$INSTALL_DIR" pull
fi

log "Installing configuration files..."

mkdir -p "$TARGET_CONFIG"

for item in "$SOURCE_CONFIG"/*; do
    name=$(basename "$item")
    dest="$TARGET_CONFIG/$name"
    backup="$TARGET_CONFIG/$name.bak"

    if [ -e "$dest" ]; then
        warn "Deleting old backup: $backup"
        rm -rf "$backup"

        warn "Creating new backup: $name"
        mv "$dest" "$backup"
    fi

    log "Copying: $name"
    rm -rf "$dest"
    cp -r "$item" "$dest"
done

if [ -d "$SOURCE_FASTFETCH" ]; then
    log "Installing Fastfetch configuration..."

    mkdir -p "$TARGET_FASTFETCH"

    if [ -e "$TARGET_FASTFETCH" ]; then
        warn "Removing old fastfetch backup: $TARGET_FASTFETCH.bak"
        rm -rf "$TARGET_FASTFETCH.bak"

        warn "Backing up old fastfetch"
        mv "$TARGET_FASTFETCH" "$TARGET_FASTFETCH.bak"
    fi

    log "Copying fastfetch data..."
    rm -rf "$TARGET_FASTFETCH"
    cp -r "$SOURCE_FASTFETCH" "$TARGET_FASTFETCH"
else
    warn "fastfetch directory not found in repository — skipping"
fi

hyprctl reload -q

systemctl enable --user hyprpolkitagent

log "=== Installation complete! ==="
log "Install hyprland plugins manually:"
log "hyprpm update; hyprpm add https://github.com/virtcode/hypr-dynamic-cursors; hyprpm add https://github.com/hyprwm/hyprland-plugins; hyprpm enable dynamic-cursors; hyprpm enable hyprbars"
log "Reboot and enjoy!"
