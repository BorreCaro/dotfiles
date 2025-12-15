#!/bin/bash
set -e # Detener el script si hay algún error

echo ">>> Iniciando instalación completa de dotfiles para Fedora..."

# 1. Actualizar el sistema
echo ">>> Actualizando sistema..."
sudo dnf update -y

# 2. Instalar dependencias generales y herramientas de línea de comandos
# Se incluyen: git, compiladores, python, herramientas de búsqueda (rg, fd), y utilidades
echo ">>> Instalando herramientas base y dependencias de Neovim/Shell..."
sudo dnf install -y \
  git \
  gcc gcc-c++ \
  make cmake automake \
  python3 python3-pip \
  ripgrep \
  fd-find \
  unzip \
  wget curl \
  neovim python3-neovim \
  zsh \
  fzf \
  zoxide \
  lsd \
  fastfetch \
  rust cargo \
  npm nodejs \
  wl-clipboard # Útil para portapapeles en Wayland (necesario para nvim/ghostty)

# Nota: En Fedora, el paquete 'fd' se llama 'fd-find'. El binario suele ser 'fd'.

# 3. Instalar dependencias para 'silicon' (generador de imágenes de código)
# Requiere librerías de desarrollo de fuentes y gráficos
echo ">>> Instalando dependencias para Silicon..."
sudo dnf install -y \
  expat-devel fontconfig-devel libxcb-devel freetype-devel libxml2-devel harfbuzz-devel

# 4. Instalar Silicon vía Cargo
echo ">>> Compilando e instalando Silicon..."
cargo install silicon

# 5. Configuración de la Shell (Zsh, Oh My Zsh, Plugins)
echo ">>> Configurando Zsh y plugins..."

# Instalar Oh My Zsh (si no existe)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo ">>> Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Instalar plugins de Zsh definidos en tu .zshrc
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
mkdir -p "$ZSH_CUSTOM/plugins"

echo ">>> Clonando plugins de Zsh..."
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

# Instalar Pokemon-colorscripts
echo ">>> Instalando Pokemon Colorscripts..."
if ! command -v pokemon-colorscripts &> /dev/null; then
  git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git /tmp/pokemon-colorscripts
  pushd /tmp/pokemon-colorscripts
  sudo ./install.sh
  popd
  rm -rf /tmp/pokemon-colorscripts
fi

# 6. Instalar Gestores de Versiones (FNM y SDKMAN)
echo ">>> Instalando FNM (Node manager)..."
if [ ! -d "$HOME/.local/share/fnm" ]; then
  curl -fsSL https://fnm.vercel.app/install | bash
fi

echo ">>> Instalando SDKMAN (Java manager)..."
if [ ! -d "$HOME/.sdkman" ]; then
  curl -s "https://get.sdkman.io" | bash
fi

# 7. Compilación de Ghostty
echo ">>> Preparando entorno para Ghostty..."
# Instalamos las dependencias de compilación para Ghostty
sudo dnf install -y \
  gtk4-devel \
  gtk4-layer-shell-devel \
  libadwaita-devel \
  gettext \
  blueprint-compiler # A veces requerido en versiones nuevas de Fedora

# Intenta instalar zig específico si está disponible, sino el estándar
if ! sudo dnf install -y zig-0.14.1 2>/dev/null; then
    echo "⚠️  El paquete 'zig-0.14.1' no se encontró. Instalando 'zig' estándar. Verifica la versión con 'zig version'."
    sudo dnf install -y zig
fi

echo ">>> Compilando Ghostty (según tus instrucciones)..."
# Bloque específico del usuario
cd "$HOME" # O donde prefieras descargar
curl -L -O https://release.files.ghostty.org/1.2.3/ghostty-1.2.3.tar.gz
tar -xf ghostty-1.2.3.tar.gz
cd ghostty-1.2.3
# Usamos el path del sistema /usr para que sea global, o puedes usar $HOME/.local
sudo zig build -p /usr -Doptimize=ReleaseFast -Demit-themes=false
cd ..
rm -rf ghostty-1.2.3 ghostty-1.2.3.tar.gz

# 8. Configuración final de Neovim
echo ">>> Sincronizando plugins de Neovim..."
# Esto instalará todos los plugins definidos en lazy-lock.json y init.lua
nvim --headless "+Lazy! sync" +qa

echo ">>> ¡Instalación completada! Reinicia tu terminal o haz 'source ~/.zshrc'."
