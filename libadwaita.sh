#!/bin/bash
TEMP="$HOME/Downloads/TempLibAdw"
mkdir -p "$TEMP"
git clone https://github.com/odziom91/libadwaita-theme-changer.git "$TEMP/libadwaita-theme-changer"
pushd "$TEMP/libadwaita-theme-changer" > /dev/null
  sudo chmod +x libadwaita-tc.py
  ./libadwaita-tc.py
popd > /dev/null

