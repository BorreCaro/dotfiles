#!/bin/bash
set -e # Detener el script si hay errores

# Directorio del script para encontrar el zip del cursor
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ">>> Iniciando instalación ULTIMATE v2 (Fedora + Ghostty + Nemo + WhiteSur + Copyous)..."

# ===============================================
# 1. ACTUALIZACIÓN Y PAQUETES DE SISTEMA
# ===============================================
echo ">>> 1. Actualizando e instalando paquetes base..."
sudo dnf update -y
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y \
  git cmake \
  python3 python3-pip \
  unzip wget curl \
  zsh \
  neovim python3-neovim \
  rust cargo \
  npm nodejs \
  wl-clipboard \
  flatpak \
  java-21-openjdk-devel \
  nemo \
  gnome-tweaks \
  libgda libgda-sqlite # Dependencias para Copyous

# ===============================================
# 2. UTILIDADES DE TERMINAL (TUI)
# ===============================================
echo ">>> 2. Instalando herramientas TUI..."
sudo dnf install -y \
  ripgrep \
  fd-find \
  fzf \
  zoxide \
  lsd \
  fastfetch \
  lazygit \
  bat \
  tldr

# ===============================================
# 3. APPS FLATPAK Y EXTENSIONES
# ===============================================
echo ">>> 3. Instalando Extension Manager y Copyous..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.mattjakeman.ExtensionManager

# --- Copyous Extension ---
COPYOUS_URL="https://github.com/boerdereinar/copyous/releases/download/v1.2.0/copyous@boerdereinar.dev.zip"
COPYOUS_DEST="$HOME/Downloads/copyous@boerdereinar.dev.zip"

echo "    -> Descargando Copyous en $COPYOUS_DEST..."
wget -O "$COPYOUS_DEST" "$COPYOUS_URL"

echo "    -> Instalando extensión Copyous..."
# Forzamos la instalación desde el zip descargado
gnome-extensions install -f "$COPYOUS_DEST"

# Intentamos habilitarla (puede requerir reinicio de sesión en Wayland, pero lo intentamos)
if gnome-extensions list | grep -q "copyous@boerdereinar.dev"; then
    echo "    -> Habilitando Copyous..."
    gnome-extensions enable copyous@boerdereinar.dev
else
    echo "⚠️  La extensión se instaló. Si no se habilita ahora, reinicia la sesión y actívala en 'Extensiones'."
fi

# ===============================================
# 4. TEMAS WHITESUR (GTK & ICONS)
# ===============================================
echo ">>> 4. Instalando WhiteSur (GTK e Iconos)..."
THEME_TEMP="$HOME/Downloads/WhiteSur_Install"
mkdir -p "$THEME_TEMP"

# --- GTK Theme ---
echo "    -> Clonando WhiteSur GTK..."
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme "$THEME_TEMP/WhiteSur-gtk-theme"
pushd "$THEME_TEMP/WhiteSur-gtk-theme" > /dev/null
  ./install.sh -l -N glassy -t red -c dark -HD
  sudo ./tweaks.sh -g -f flat -F -c dark -t red
popd > /dev/null

# --- Icon Theme ---
echo "    -> Clonando WhiteSur Icons..."
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme "$THEME_TEMP/WhiteSur-icon-theme"
pushd "$THEME_TEMP/WhiteSur-icon-theme" > /dev/null
  ./install.sh -t red
popd > /dev/null

rm -rf "$THEME_TEMP"

# ===============================================
# 5. CURSOR MOGA-CANDY-BLACK
# ===============================================
echo ">>> 5. Instalando Cursor Moga-Candy-Black..."
CURSOR_ZIP="$SCRIPT_DIR/Moga-Candy-Black.zip"
ICON_DIR="$HOME/.local/share/icons"
mkdir -p "$ICON_DIR"

if [ -f "$CURSOR_ZIP" ]; then
  echo "    -> Descomprimiendo cursor..."
  unzip -o "$CURSOR_ZIP" -d "$ICON_DIR"
  rm "$CURSOR_ZIP"
else
  echo "⚠️  AVISO: No se encontró 'Moga-Candy-Black.zip' junto al script."
fi

# ===============================================
# 6. CONFIGURACIÓN NEMO
# ===============================================
echo ">>> 6. Configurando Nemo (Default + Ghostty Action)..."
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

# Acción: Abrir Ghostty Aquí
NEMO_ACTIONS_DIR="$HOME/.local/share/nemo/actions"
mkdir -p "$NEMO_ACTIONS_DIR"
cat > "$NEMO_ACTIONS_DIR/ghostty.nemo_action" <<EOF
[Nemo Action]
Active=true
Name=Abrir Ghostty Aquí
Comment=Abrir terminal Ghostty en este directorio
Exec=ghostty
Icon=ghostty
Selection=None
Extensions=dir;
Quote=double
EOF

# ===============================================
# 7. FUENTES (AGAVE NERD FONT)
# ===============================================
echo ">>> 7. Instalando Agave Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
wget -O /tmp/Agave.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Agave.zip"
unzip -o /tmp/Agave.zip -d "$FONT_DIR"
rm /tmp/Agave.zip
fc-cache -fv

# ===============================================
# 8. SILICON (Rust)
# ===============================================
echo ">>> 8. Instalando Silicon..."
sudo dnf install -y expat-devel fontconfig-devel libxcb-devel freetype-devel libxml2-devel harfbuzz-devel
if ! command -v silicon &> /dev/null; then
  cargo install silicon
fi

# ===============================================
# 9. ZSH & PLUGINS
# ===============================================
echo ">>> 9. Configurando Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
mkdir -p "$ZSH_CUSTOM/plugins"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

if ! command -v pokemon-colorscripts &> /dev/null; then
  git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git /tmp/pokemon-colorscripts
  pushd /tmp/pokemon-colorscripts > /dev/null
  sudo ./install.sh
  popd > /dev/null
  rm -rf /tmp/pokemon-colorscripts
fi

# ===============================================
# 10. GESTORES DE VERSIONES
# ===============================================
echo ">>> 10. Instalando FNM y SDKMAN..."
[ ! -d "$HOME/.local/share/fnm" ] && curl -fsSL https://fnm.vercel.app/install | bash
[ ! -d "$HOME/.sdkman" ] && curl -s "https://get.sdkman.io" | bash

# ===============================================
# 11. COMPILAR GHOSTTY
# ===============================================
echo ">>> 11. Compilando Ghostty..."
sudo dnf install -y gtk4-devel gtk4-layer-shell-devel libadwaita-devel gettext blueprint-compiler

if ! sudo dnf install -y zig-0.14.1 2>/dev/null; then
    sudo dnf install -y zig
fi

cd "$HOME"
curl -L -O https://release.files.ghostty.org/1.2.3/ghostty-1.2.3.tar.gz
tar -xf ghostty-1.2.3.tar.gz
cd ghostty-1.2.3
sudo zig build -p /usr -Doptimize=ReleaseFast -Demit-themes=false
cd ..
rm -rf ghostty-1.2.3 ghostty-1.2.3.tar.gz

# ===============================================
# 12. NEOVIM (PLUGINS + MASON)
# ===============================================
echo ">>> 12. Configurando Neovim..."
echo "    -> Sincronizando plugins (Lazy)..."
nvim --headless "+Lazy! sync" +qa
echo "    -> Instalando herramientas (Mason)..."
nvim --headless "+MasonInstallAll" +qa

echo ">>> ¡Instalación completada!"
echo "    Recordatorio: Si Copyous no aparece activo, reinicia sesión y actívalo desde GNOME Tweaks o Extension Manager."
