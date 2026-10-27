<img src="docs/logo.png" width="150" align="left"/>

## exDesktop for Linux
*[Licensed under the GNU General Public License v3.0](LICENSE)*

An unofficial **Linux port** of [exDesktop](https://github.com/metawka/exDesktop) by [@metawka](https://t.me/metawka), which is a fork of the official [Telegram Desktop](https://github.com/telegramdesktop/tdesktop). It keeps exDesktop's settings suite, channel feed, streamer tools and Python plugin engine, and makes them work natively on Linux.

This fork is not affiliated with Telegram or with the exDesktop author. Upstream changes are merged from `metawka/exDesktop`; Linux work lives on the `linux` branch.

![exDesktop settings](docs/screenshots/main.png)

## What differs from upstream exDesktop
- **Plugins use the system Python** (3.11 or newer, linked at build time) instead of the embedded Windows runtime. The plugin layer is installed to `share/exdesktop/python/extera`.
- **Separate identity.** The binary is installed as `exDesktop` with app id `org.exdesktop.desktop`, so it coexists with `telegram-desktop` and other forks.
- **Separate data.** Everything is stored in `~/.local/share/exDesktop`, never in Telegram Desktop's folder.
- **One-time account import from 64Gram.** On the first launch with an empty profile, login keys, settings and account maps are copied from `~/.local/share/64Gram/tdata` (media caches are skipped, the source is never modified). Don't keep the same account open in both clients at once, Telegram may end the session.
- **Update checks** look at this fork's releases, not upstream's Windows builds.
- Streamer mode's screen capture protection is Windows-only and has no effect on Linux.

## Features (inherited from exDesktop)
- Settings for General, Appearance, Chats, Navigation, Plugins and Other.
- Material Design 3 controls, adjustable avatar corners and 33 application icons.
- Channel feed, wide posts, precise timestamps, edit marks and forward counts.
- Streamer mode with per chat settings and exceptions.
- Python plugin engine with per plugin settings and automatic safe mode after crashes.
- Gemini chat with your own API key.
- User IDs, data center and estimated registration date in profiles.

![Plugin manager](docs/screenshots/plugins.png)

## Build on Arch Linux
Install the dependencies listed in the [telegram-desktop PKGBUILD](https://gitlab.archlinux.org/archlinux/packaging/packages/telegram-desktop) (including the makedepends) plus `python`:

```
sudo pacman -S --needed cmake ninja just gperf python boost range-v3 tl-expected microsoft-gsl \
  vulkan-headers ada libheif tlottie libtg_owt libfido2 libjxl libavif libsrtp openh264 \
  qt6-base qt6-declarative qt6-svg qt6-wayland qt6-imageformats qt6-shadertools \
  ffmpeg openal pipewire hunspell kcoreaddons rnnoise xxhash lz4 minizip abseil-cpp cargo
```

Then:

```
git clone --recurse-submodules -b linux https://github.com/ForGetMyAlias/exDesktop.git
cd exDesktop
./build-linux.sh                 # or: ./build-linux.sh API_ID API_HASH
out/bin/Telegram
```

`build-linux.sh` mirrors the Arch `telegram-desktop` recipe: it builds `wallet-engine` and `td` (tde2e) into `.deps/`, then the client into `out/`. The first build compiles about 2400 files and takes an hour or more on 12 cores. Re-running resumes where it stopped.

By default the script uses Telegram's public snap API key. For your own builds get an API ID and hash from [Telegram's API credentials page](https://core.telegram.org/api/obtaining_api_id) and pass them as arguments.

Install system-wide with `sudo cmake --install out` (binary `exDesktop`, desktop entry, icons, plugin layer).

Other distributions: follow the [Telegram Desktop Linux build guide](docs/building-linux.md) and replace the final configure step with the CMake options used in `build-linux.sh`.

## Build on Windows
1. Follow the [Telegram Desktop Windows build guide](https://github.com/telegramdesktop/tdesktop/blob/dev/docs/building-win.md).
2. Put the embedded Python 3.11 runtime in `Libraries/win64/python311` (headers, `python311.lib` and the `embed` folder).
3. Generate the project files with your API ID and hash:

```
python configure.py x64 -D TDESKTOP_API_ID=123456 -D TDESKTOP_API_HASH=abcdef0123456789abcdef0123456789
cmake --build out --config Release --target Telegram
```

Windows binaries are published by the upstream project: [metawka/exDesktop releases](https://github.com/metawka/exDesktop/releases).

## Localization
Most strings follow Telegram Desktop translations. exDesktop specific strings are available in English and Russian.

## Thanks
- [metawka](https://github.com/metawka) for exDesktop
- [Telegram Desktop](https://github.com/telegramdesktop/tdesktop)
- [AyuGram Desktop](https://github.com/AyuGram/AyuGramDesktop)
- [64Gram](https://github.com/TDesktop-x64/tdesktop)
