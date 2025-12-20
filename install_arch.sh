#!/usr/bin/env bash

confirm_action() {
    read -p "[?] Are you sure you want to proceed? [Y/n]: " choice
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
    polkit-kde-agent cmake meson cpio pkg-config git gcc noctalia-shell gum walogram hyprcursor catppuccin-cursors-latte glava

log "Make sure to have hypr/kitty configuration backups."
confirm_action

if [ ! -d "$INSTALL_DIR" ]; then
    log "Cloning repo into $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR"
else
    log "Updating repo..."
    git -C "$INSTALL_DIR" pull
fi

log "Installing wallpapers..."
cp -r $INSTALL_DIR/dots/wallpapers/ $HOME/ ||

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

log "Installing screenshot utility..."
git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot

log "Installing overview..."
git clone https://github.com/Shanu-Kumawat/quickshell-overview ~/.config/quickshell/overview

log "=== Installing hyprland plugins... ==="

confirm_action

hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins ||
hyprpm add https://github.com/virtcode/hypr-dynamic-cursors ||
hyprpm enable hyprbars ||
hyprpm enable dynamic-cursors ||

if [ -d /run/systemd/system ]; then
    log "Installing polkit agent for systemd..."
    yay -S hyprpolkitagent
    systemctl enable --user hyprpolkitagent
else
    echo
    echo
    log "=== Installation complete! ==="
fi

qs -c noctalia-shell ipc call wallpaper random ||

echo
echo
log "=== Installation complete! ==="
