#!/bin/bash
set -e # Detener el script si hay errores

# Cachear credenciales de sudo al inicio
echo ">>> Activando sudo..."
sudo echo "Sudo activado correctamente."

# Directorio del script para encontrar archivos locales (zip, configs)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



echo ">>> Iniciando instalación ULTIMATE v8 (Fedora + Ghostty + Nemo + Orchis + Tela + P10K Fix)..."

# ===============================================
# 1. ACTUALIZACIÓN Y PAQUETES DE SISTEMA
# ===============================================
echo ">>> 1. Actualizando e instalando paquetes base..."
sudo dnf update -y

# Instalación del grupo de desarrollo
echo "    -> Instalando Development Tools..."
sudo dnf group install -y development-tools

# Instalamos dependencias específicas
echo "    -> Instalando dependencias del sistema..."
sudo dnf install -y \
  git cmake \
  gcc-c++ libstdc++-devel \
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
  dnf-plugins-core \
  tree-sitter-cli \
  libgda libgda-sqlite # Dependencias para Copyous

# ===============================================
# 2. UTILIDADES DE TERMINAL (TUI)
# ===============================================
echo ">>> 2. Instalando herramientas TUI..."

# Habilitar COPR para LazyGit
echo "    -> Habilitando COPR atim/lazygit..."
sudo dnf copr enable -y atim/lazygit

sudo dnf install -y \
  ripgrep \
  fd-find \
  fzf \
  zoxide \
  lsd \
  fastfetch \
  lazygit \
  bat \
  tldr \
  procps-ng
# 2.1 Copiar todo el contenido de .config/ (nvim, ghostty, etc.) a ~/.config/
echo "    -> Copiando .config/ a ~/.config/ (Necesario para Nvim)..."
cp -rf "$SCRIPT_DIR"/.config/* "$HOME"/.config/
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
gnome-extensions install -f "$COPYOUS_DEST"
echo "    -> Extensión instalada. Recuerda habilitarla tras reiniciar."

# ===============================================
# 3.5. PREPARACIÓN FIREFOX (Perfil)
# ===============================================
echo ">>> 3.5. Inicializando Firefox para generar perfiles..."
nohup firefox > /dev/null 2>&1 &
echo "    -> Firefox iniciado, esperando 10 segundos..."
sleep 10
echo "    -> Cerrando TODOS los procesos de Firefox..."
pkill -f firefox || true
sleep 2

# ===============================================
# 4. TEMAS: ORCHIS (GTK) & TELA (ICONS)
# ===============================================
echo ">>> 4. Instalando Temas (Orchis & Tela)..."
THEME_TEMP="$HOME/Downloads/Theme_Install"
mkdir -p "$THEME_TEMP"

# --- Orchis GTK Theme ---
echo "    -> Clonando Orchis GTK Theme..."
git clone https://github.com/vinceliuice/Orchis-theme.git "$THEME_TEMP/Orchis-theme"
pushd "$THEME_TEMP/Orchis-theme" > /dev/null
  echo "    -> Aplicando tema Orchis..."
  ./install.sh -i apple -t red -c dark --tweaks macos dock

  echo "    -> Aplicando overrides de Flatpak..."
  sudo flatpak override --filesystem=xdg-config/gtk-3.0
  sudo flatpak override --filesystem=xdg-config/gtk-4.0

  echo "    -> Configurando tema en Firefox..."
  for profile in $HOME/.mozilla/firefox/*default*; do
    if [ -d "$profile" ]; then
      echo "       Aplicando en perfil: $profile"
      mkdir -p "$profile/chrome"
      cp -r src/firefox/chrome/* "$profile/chrome/"
      cp src/firefox/configuration/user.js "$profile/"
    fi
  done
popd > /dev/null

# --- Tela Icon Theme ---
echo "    -> Clonando Tela Icon Theme..."
git clone https://github.com/vinceliuice/Tela-icon-theme.git "$THEME_TEMP/Tela-icon-theme"
pushd "$THEME_TEMP/Tela-icon-theme" > /dev/null
  echo "    -> Instalando iconos Tela (Red)..."
  ./install.sh red
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
  echo "    -> Descomprimiendo cursor en temporal..."
  TEMP_CURSOR="/tmp/moga_cursor_temp"
  rm -rf "$TEMP_CURSOR"
  mkdir -p "$TEMP_CURSOR"
  
  unzip -o "$CURSOR_ZIP" -d "$TEMP_CURSOR" > /dev/null
  
  TARGET_DIR="$TEMP_CURSOR/Moga-Candy-Black/Moga-Candy-Black"
  if [ -d "$TARGET_DIR" ]; then
      echo "    -> Moviendo carpeta correcta a $ICON_DIR..."
      rm -rf "$ICON_DIR/Moga-Candy-Black"
      mv "$TARGET_DIR" "$ICON_DIR/"
  else
      echo "⚠️  Estructura inesperada. Moviendo raíz..."
      rm -rf "$ICON_DIR/Moga-Candy-Black"
      mv "$TEMP_CURSOR/Moga-Candy-Black" "$ICON_DIR/"
  fi
  
  rm -rf "$TEMP_CURSOR"
  rm "$CURSOR_ZIP"
else
  echo "⚠️  AVISO: No se encontró 'Moga-Candy-Black.zip'. Saltando."
fi

# ===============================================
# 6. CONFIGURACIÓN NEMO
# ===============================================
echo ">>> 6. Configurando Nemo..."
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

# 1. Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "    -> Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 2. Instalar Powerlevel10k (Tema)
echo "    -> Clonando Powerlevel10k..."
# Borramos si existe para asegurar instalación limpia
rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# 3. Plugins adicionales
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
mkdir -p "$ZSH_CUSTOM/plugins"
echo "    -> Clonando plugins de Zsh..."
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

# 4. Pokemon Colorscripts
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
sudo rm -rf ghostty-1.2.3 ghostty-1.2.3.tar.gz

# ===============================================
# 12. NEOVIM (PLUGINS + MASON)
# ===============================================
echo ">>> 12. Configurando Neovim..."

# Limpiar caché de Treesitter para evitar conflictos
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter 2>/dev/null || true

echo "    -> Sincronizando plugins (Lazy)..."
nvim "+Lazy sync" +qa

echo "    -> Instalando herramientas (Mason)..."
nvim "+MasonInstallAll" +qa

# ===============================================
# 13. RESTAURAR DOTFILES (ZSHRC & P10K)
# ===============================================
echo ">>> 13. Restaurando archivos de configuración (.zshrc y .p10k.zsh)..."

# Buscamos los archivos en el directorio donde se ejecuta el script (el repo)
LOCAL_ZSHRC="$SCRIPT_DIR/.zshrc"
LOCAL_P10K="$SCRIPT_DIR/.p10k.zsh"

if [ -f "$LOCAL_ZSHRC" ]; then
    echo "    -> Copiando .zshrc a $HOME..."
    cp -f "$LOCAL_ZSHRC" "$HOME/.zshrc"
else
    echo "⚠️  No se encontró .zshrc en el directorio del script. Verifica tu repo."
fi

if [ -f "$LOCAL_P10K" ]; then
    echo "    -> Copiando .p10k.zsh a $HOME..."
    cp -f "$LOCAL_P10K" "$HOME/.p10k.zsh"
else
    echo "⚠️  No se encontró .p10k.zsh en el directorio del script. Verifica tu repo."
fi

echo ">>> ¡Instalación ULTIMATE completada!"
echo "    - Reinicia el sistema."
echo "    - Abre Ghostty y disfruta."
