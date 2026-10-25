# EDuke32 for MiSTer: notes

How the port works and how it is built. For playing it, see the [README](README.md).

## Music

Duke Nukem 3D's music is MIDI, written for the sound cards of 1996. With the OSD's *Music* on **MIDI** (the default), its General MIDI tracks are played by a SoundFont 2 synthesizer in the FPGA core, with GeneralUser GS, which comes with the port, or a SoundFont of your own (*SoundFont* 1 to 7, `.sf2` files in `games/dnk/SoundFonts/`). The game's *Music* volume sets its level.

With *Music* on **FM chip**, it plays as an AdLib or Sound Blaster card did, on a YM3812 (OPL2) in the FPGA core, [JTOPL](https://github.com/jotego/jtopl). The game runs the AdLib driver of the original (the Apogee Sound System's, with the game's own instruments from its `D3DTIMBR.TMB`) and sends the core the chip's register writes, each with the audio sample it is due at; the chip's sound is made in the FPGA and mixed with the game's. The music needs the core of the same release.

**With an [MT32-pi](https://github.com/dwhinham/mt32-pi)** on the MiSTer's user port (an MT32-pi board for the MiSTer, with the firmware's MiSTer support) and *Music* on MIDI, the music goes to it instead of the synthesizer. The OSD then shows its lines (they are hidden while no MT32-pi answers): *MT32-pi* **On** (default) or **Off** (the core's synthesizer, as without it), *MT32-pi Synth* **SoundFont** (default) or **MT-32** (it needs the MT-32 ROMs on the MT32-pi's card), *MT32-pi ROM* (MT-32 v1, v2, CM-32L) and *MT32-pi SoundFont* (**Pi's own**, the default: the one the MT32-pi has, as set on it; or one of the first eight on its card, 0 to 7). A box names the synth each time it changes; *Reset Hanging Notes* makes the MT32-pi stop all its notes, and the music goes on (the SoundFont stays). All apply at once; the game's *Music* volume sets its level.

## Frame pacing

Duke Nukem 3D moves 30 times per second. A 15kHz picture a TV accepts has about 60 fields per second: the core shows 59.64. This build draws exactly one frame per field, with the game's clock taken from the field counter of the core instead of the system clock, and puts everything that moves between its last two positions for the time of that field, as EDuke32 does on any monitor.

## Building

Everything builds in Docker on a Linux PC.

```sh
git clone --recursive https://github.com/ItsDanik/EDuke32_MiSTer.git
cd EDuke32_MiSTer
./build.sh              # ARM game binary  -> build/mister/eduke32
./core/build_core.sh    # FPGA core (Quartus Lite 17.0.2) -> core/output_files/EDuke32.rbf
./package.sh            # release zip      -> dist/EDuke32_YYYYMMDD.zip
```

The toolchain image (Debian bullseye, glibc 2.31 to match the MiSTer) is built from `hybrid/toolchain/` on first use. The first build also downloads and builds SDL2, SDL2_mixer and SDL2_net.

### Repository layout

| Path | |
|---|---|
| `hybrid/` | submodule: [ItsDanik/Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), what all our hybrid ports share: the FPGA host module, the ARM side library, SDL2 drivers, the launcher (`danik_hybrid_ports.sh`), toolchain and conventions. See its README. |
| `core/` | FPGA core, based on [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer): `EDuke32.sv` (OSD and button names) around `hybrid/rtl/hybrid_host.sv` |
| `eduke32/` | submodule: [ItsDanik/eduke32](https://github.com/ItsDanik/eduke32) branch `mister`, [EDuke32](https://voidpoint.io/terminx/eduke32) with the MiSTer changes behind `MISTER_HYBRID` (`Common.mak`, `GNUmakefile`): the game's part in `source/duke3d/src/mister_port.cpp`, the engine's (video, clock, joystick) in `source/build/src/sdlayer.cpp` and `timer.cpp`, and the MIDI driver for the core's FM chip in `source/audiolib/src/driver_misterfm.cpp` |
| `package/` | files shipped in the release next to the binary (`danik_hybrid_launch.sh`, README), `games.txt`: the games and their menu entries, and `logos/`: each game's logo, shown while it starts |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm MISTER_HYBRID_CORE=EDuke32 MISTER_HYBRID_SET=EDuke32_DN3D <repository>/build/host/eduke32 -usecwd
  ```
- `MISTER=root@<address> tools/test_on_mister.sh DN3D` tries the build on a MiSTer next to what is installed there, without installing it: from `/tmp`, with the installed game's folder mirrored there (what the game writes stays in `/tmp`) and its own OSD settings. `DC`, `VACA`, `NW`, `DZ2`, `PP` for the add-ons, `list` and `nodata` for the core started by itself and without data, `log` for the game's log, `stop` to remove all of it again.
- `touch /tmp/eduke32_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (set `MISTER_HYBRID_CORE=EDuke32`, and `MISTER_HYBRID_SET` for a game's set name, e.g. `EDuke32_DC`). `/tmp/danik_hybrid_ports.log` shows what the launcher daemon did.
