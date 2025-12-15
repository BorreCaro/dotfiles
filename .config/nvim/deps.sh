#!/bin/bash
# Esta monda es solo con zypper porque tumbleweed es el goat
sudo zypper refresh
sudo zypper install -y \
  git \
  gcc gcc-c++ \
  python3 \
  ripgrep \
  fd \
  unzip \
  make \
  pandoc \
  rust
cargo install silicon
nvim --headless "+Lazy! sync" +qa
