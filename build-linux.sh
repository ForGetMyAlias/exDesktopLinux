#!/usr/bin/env bash
# Native Arch build, mirrors the telegram-desktop 7.3.3 PKGBUILD. Usage: ./build-linux.sh [API_ID API_HASH]
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"  # pipx cmake: pacman cmake needs newer jsoncpp (sudo pacman -S jsoncpp)
cd "$(dirname "$0")"
ID=${1:-611335}; HASH=${2:-d524b414d21f4d37f08684c1df41ac9c}  # default: Telegram's public snap key; use your own for releases
W=$PWD/.deps; mkdir -p "$W"; cd "$W"
TD_COMMIT=c15d3f5a5de6e3ba5839822c451152e5e18bb700; WE=0.0.7

if [ ! -d wallet-engine ]; then
  mkdir wallet-engine && curl -sL https://github.com/i582/wallet-engine/archive/refs/tags/v$WE.tar.gz | tar xz -C wallet-engine --strip-components=1
  curl -sL https://github.com/desktop-app/patches/raw/refs/heads/master/wallet-engine.patch | patch -d wallet-engine -Np1
  (cd wallet-engine && just build && just bindings-cpp \
    && install -Dm644 target/release/libwallet_engine.a -t install/lib/ \
    && install -Dm644 bindings/cpp-experimental/* -t install/include/wallet_engine/)
fi
if [ ! -d td/install ]; then
  [ -d td ] || { git clone https://github.com/tdlib/td.git; git -C td checkout $TD_COMMIT; }
  cmake -S td -B td/build -DCMAKE_BUILD_TYPE=None -DCMAKE_INSTALL_PREFIX="$W/td/install" -Wno-dev -DTD_E2E_ONLY=ON
  cmake --build td/build && cmake --install td/build
fi
cd ..
cmake -B out -S . -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -Dtde2e_DIR="$W/td/install/lib/cmake/tde2e" -DCMAKE_PREFIX_PATH="$W/wallet-engine/install" \
  -DTDESKTOP_API_ID="$ID" -DTDESKTOP_API_HASH="$HASH"
cmake --build out
