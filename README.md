# EDuke32 for MiSTer

Duke Nukem 3D and its add-ons Duke It Out in D.C., Life's a Beach and Nuclear Winter on [MiSTer FPGA](https://github.com/MiSTer-devel/Main_MiSTer/wiki) as a hybrid port.

The game is [EDuke32](https://www.eduke32.com), the source port of 3D Realms' Duke Nukem 3D (1996) by Richard "TerminX" Gobeille, Evan "Hendricks266" Ramos and its contributors, on Ken Silverman's Build engine, with the engine's classic software renderer. It runs on the MiSTer's ARM CPU. The EDuke32 FPGA core provides native 15kHz video (CRT, VGA and HDMI) at 320x200, 640x200, 320x240 or 640x240, 44.1kHz audio, a MIDI synthesizer and an FM chip for the game's music, and keyboard, mouse and gamepad input with rumble. The two halves talk through shared DDR3 memory.

> **Beta.** Expect rough edges and please report problems in the issues.

Disclaimer: AI is being used to speed up development of this project.

## Requirements

- **danik_hybrid_ports**, the launcher (`Scripts/danik_hybrid_ports.sh`): run it **once** from the MiSTer's `Scripts` menu. It starts the game whenever its menu entry is loaded, keeps running after a reboot, and serves all our hybrid ports; its screen picks which ports and games to have, and can keep them up to date through `update_all`. It replaces `danik_hybrid_cores`, the launcher before it, and moves ports installed the old way into the new folders by itself. Without it the core says "Game not running".
- **Game data**, which is not included: `DUKE3D.GRP` of Duke Nukem 3D, version 1.3D or the Atomic Edition (1.4 or 1.5: from the original CD, *Megaton Edition* or the GOG release), or of the shareware version. The add-ons are optional and need the full game's `DUKE3D.GRP` as well: *Duke It Out in D.C.* (`DUKEDC.GRP`) and *Life's a Beach* (`VACATION.GRP`) of the same version as it (1.3D or Atomic), *Nuclear Winter* (`NWINTER.GRP`) with the Atomic Edition.

## Installation

With `update_all` (Downloader 2.4 or newer, which update_all keeps up to date):

1. Copy [`downloader_danik_hybrid_ports.ini`](https://raw.githubusercontent.com/ItsDanik/Hybrid_MiSTer/main/launcher/downloader_danik_hybrid_ports.ini) to the root of your SD card (`/media/fat`).
2. Run `update_all`. That installs the launcher, **danik_hybrid_ports**, in `Scripts`.
3. Run **danik_hybrid_ports** from the `Scripts` menu, tick the games you want and press *X: Apply*. They are installed, and update_all keeps them up to date.

By hand:

1. Download the newest `EDuke32_YYYYMMDD.zip` from [releases](releases/) and extract it to the root of your SD card (`/media/fat`). That gives you:
   - `_Other/dnk-Duke Nukem 3D.mgl`, `_Other/dnk-DN3D Duke It Out in D.C..mgl`, `_Other/dnk-DN3D Life's a Beach.mgl` and `_Other/dnk-DN3D Nuclear Winter.mgl`, the games' entries in the `Other` menu
   - `_Other/dnk/dnk-EDuke32_YYYYMMDD.rbf`, the FPGA core
   - `games/dnk/EDuke32/`, the game binary and its launch script
   - `games/dnk/SoundFonts/`, GeneralUser GS, the SoundFont of the MIDI music
   - `Scripts/danik_hybrid_ports.sh`, the launcher (from [Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer))
   - `downloader_danik_hybrid_ports.ini`, with which `update_all` keeps the ports up to date from then on
2. Copy **everything** in the game's folder (the one with `DUKE3D.GRP`) to `/media/fat/games/dnk/EDuke32/`, with its folders as they are, and leave nothing out (files the port does not use do no harm). The port finds in it:
   - `DUKE3D.GRP`
   - optional: `DUKEDC.GRP`, `VACATION.GRP` and `NWINTER.GRP`, there or in the folders `addons/dc`, `addons/vacation` and `addons/nw`.

   The whole `gameroot` folder of *Megaton Edition* can be copied as it is: the add-ons are found in its `addons`.
3. Run **danik_hybrid_ports** from the `Scripts` menu, if you have not done so before (see Requirements).
4. Load the game from the `Other` menu, e.g. **dnk-Duke Nukem 3D**.

The game data can go on a USB drive instead, into the same folder there (`/media/usb0/games/dnk/EDuke32/`): the game looks for it there first, and then keeps its settings and saved games there as well. Everything else stays on the SD card.

The game files are known by their contents, whatever their names. The menu entry of Duke Nukem 3D starts the shareware when the full game is not there. When a game's files are missing, the core says which files to copy where. Each game keeps its own OSD settings and button mappings. The core file itself (`_Other/dnk/dnk-EDuke32_*.rbf`, or from *Recent*) lists the games that are there to pick from, other add-ons the game knows among them (Duke!ZONE II, Penthouse Paradise); quitting a game then returns to the list. The game's log is in `/media/fat/logs/dnk/EDuke32/eduke32.log`. Settings (`eduke32.cfg`, `settings.cfg`) are in `/media/fat/games/dnk/EDuke32/`, as are the saved games of Duke Nukem 3D (`save0000.esv` and on); each add-on keeps its saved games in a folder of its own there, `DC`, `VACA` and `NW` (all of it on the USB drive, if the game data is there).

## OSD options

| Option | |
|---|---|
| Aspect ratio, Scale, Scandoubler Fx, Stereo Mix | as in other cores |
| FPS Counter | shows the pictures per second in the top left corner |
| HDMI Only | **Yes** if no CRT is connected: resolutions of 640x400 and more are then progressive instead of interlaced, and the analog output is switched off while one is shown, so that a 15kHz screen can never get such a signal. This game has no such resolution, so nothing changes. Not there with `direct_video=1` |
| CRT Options | for a 15kHz screen: *Horizontal Size*, *Horizontal Pos* and *Vertical Pos* fit the picture to it. The pixels stay as they are; HDMI is not affected. The size is for the game's picture: the core's own, with its messages, keeps its width. Not there with `forced_scandoubler=1`. *HUD (Bottom)* and *HUD (Top)*: in the 240-line resolutions, how many lines the HUD sits away from the bottom and the top edge of the screen, 0 to 24 (0 by default), so that a CRT's overscan does not hide it. The bottom margin moves the status bar (or the mini HUD) and the weapon, the top one the messages, the level's name and the frag bar. Both greyed out at 200 lines |
| Resolution | what the game renders and the core puts out, always at 15kHz: **320x200** (default, as the original), **640x200**, **320x240** or **640x240**. 640 across is twice the detail in the same place: every pixel becomes two. 240 lines are square pixels at 320 across: the view fills all of them, from the top edge to the bottom one, with the HUD drawn over it at the *HUD* margins; the menus and pictures keep their 200 lines in the middle. The artwork is never stretched. Applies at once in the game and its menu. The game's own video mode menu is not there |
| L. Stick Sensitivity, R. Stick Sensitivity | how fast the gamepad's left stick (walk, strafe) and right stick (turn, look) move the player, 25% to 300%. They apply at once, on top of the sensitivity in the game's own menu |
| Limit Vertical Look | how far the view tilts up and down. The Build engine does not turn the camera, it shifts the picture, which distorts it the further you look up or down. **On** (default) leaves half of the game's own range in both directions, **Off** is the whole range. It holds for the keys, the mouse and the gamepad alike |
| Rumble | the gamepad's rumble when you take damage, fire, land hard or something blows up nearby: **On** (default) as the game has it, **Strong** twice as strong, **Off**. Every controller that can rumble does |
| Music | the game's music, which is MIDI: **MIDI** (default), played by the core's synthesizer with a SoundFont, or by an MT32-pi when one is connected and on; **FM chip**: on the FM chip, as an AdLib or Sound Blaster card played it. *SoundFont*: **Default** is GeneralUser GS, which comes with the port (`games/dnk/SoundFonts/GeneralUser-GS.sf2`); 1 to 7 are your own `.sf2` files in that folder, in the order of their names, or as the MIDI Player core sets them. A SoundFont that is missing, damaged or too big (over 64 MB of samples) is said in the MiSTer's info box, and the music goes to the FM chip. Applies at once |
| MT32-pi | only there while an MT32-pi answers on the user port: see [Music](#music) |
| Cheats | **God Mode**: nothing hurts you while it is on. **No Clipping**: you walk through walls while it is on. **Show Full Map**: the map shows the whole level while it is on. **No Monsters**: the monsters are gone while it is on. **Give Everything**: every weapon with full ammo, armor, the inventory items and all keys; **Give Weapons**: every weapon with full ammo; **Give Keys**: all keys; each once every time it is selected. **Next Level**: the level counts as completed, as at its exit, and the next one starts (the last one of an episode ends it). As the game's own cheats, none of them at *Damn I'm Good*, nor in a demo or a user map |
| Save Diagnostic Report | the last line: see [If something is wrong](#if-something-is-wrong) |

## Controls

- **Keyboard and mouse:**

| Key | Action |
|---|---|
| W, S | Walk forward, back |
| A, D | Sidestep left, right |
| Mouse (or left, right) | Turn. Moving the mouse up and down looks up and down |
| Left mouse button (or right Ctrl) | Fire |
| E | Open, use |
| Space | Jump |
| Left Ctrl (C: on and off) | Crouch |
| Shift | Run (Caps Lock: always run) |
| 1 - 0 | Weapons |
| Mouse wheel, `'`, `;` | Next, previous weapon |
| Q | Quick kick |
| Enter, `[`, `]` | Use the inventory item, previous and next item |
| M, R, N, J, H | Medkit, steroids, night vision, jetpack, holoduke |
| Page Up, Page Down, Home, End | Look and aim up and down |
| Tab | Map |
| F6, F9 | Quick save, quick load |
| Esc | Menu |

These are EDuke32's own keys. *Options*, *Control Setup* in the game's menu changes keys and mouse; they are saved in `settings.cfg`.

- **Gamepad** (default mapping):

| Button | Action |
|---|---|
| Left stick | Walk and strafe |
| Right stick | Turn, look up and down |
| D-pad | Walk and turn |
| R (RB / R1), or R2 | Fire |
| B (Xbox A / PlayStation Cross) | Open, use |
| A (Xbox B / PlayStation Circle) | Jump |
| L (LB / L1) | Crouch |
| Y (Xbox X / PlayStation Square) | Next weapon |
| X (Xbox Y / PlayStation Triangle) | Use the inventory item. Held, with the d-pad left or right: the previous or next item (let go without the d-pad to use one) |
| L2, R3 (right stick click) | Quick kick |
| L3 (left stick click) | Run, on and off |
| Select | Map |
| Start | Menu |

L2 and R2 and the stick clicks are read from the controller itself, as MiSTer passes them on as no button.

In the game's menus the buttons that confirm and go back are the ones of your MiSTer menu, whatever they do in the game: its *Menu OK* / *Menu Back* if you set them in *Define joystick buttons*, else its A / B. A controller never set up in MiSTer confirms and goes back as on its console: Cross / Circle on PlayStation, A / B on Xbox and on Nintendo. The d-pad moves through them.

Change the buttons in the OSD under *Define EDuke32 buttons*. *Menu OK* and *Menu Back* there are only needed for a spare button without a game function. While the OSD is open, the game gets no input. The game's own button settings for the gamepad are set again at every start: the OSD is the place for them.

## Music

Duke Nukem 3D's music is MIDI, written for the sound cards of 1996. With the OSD's *Music* on **MIDI** (the default), its General MIDI tracks are played by a SoundFont 2 synthesizer in the FPGA core, with GeneralUser GS, which comes with the port, or a SoundFont of your own (*SoundFont* 1 to 7, `.sf2` files in `games/dnk/SoundFonts/`). The game's *Music* volume sets its level.

With *Music* on **FM chip**, it plays as an AdLib or Sound Blaster card did, on a YM3812 (OPL2) in the FPGA core, [JTOPL](https://github.com/jotego/jtopl). The game runs the AdLib driver of the original (the Apogee Sound System's, with the game's own instruments from its `D3DTIMBR.TMB`) and sends the core the chip's register writes, each with the audio sample it is due at; the chip's sound is made in the FPGA and mixed with the game's. The music needs the core of the same release.

**With an [MT32-pi](https://github.com/dwhinham/mt32-pi)** on the MiSTer's user port (an MT32-pi board for the MiSTer, with the firmware's MiSTer support) and *Music* on MIDI, the music goes to it instead of the synthesizer. The OSD then shows its lines (they are hidden while no MT32-pi answers): *MT32-pi* **On** (default) or **Off** (the core's synthesizer, as without it), *MT32-pi Synth* **SoundFont** (default) or **MT-32** (it needs the MT-32 ROMs on the MT32-pi's card), *MT32-pi ROM* (MT-32 v1, v2, CM-32L) and *MT32-pi SoundFont* (**Pi's own**, the default: the one the MT32-pi has, as set on it; or one of the first eight on its card, 0 to 7). A box names the synth each time it changes; *Reset Hanging Notes* makes the MT32-pi stop all its notes, and the music goes on (the SoundFont stays). All apply at once; the game's *Music* volume sets its level.

## Frame pacing

Duke Nukem 3D moves 30 times per second. A 15kHz picture a TV accepts has about 60 fields per second: the core shows 59.64. This build draws exactly one frame per field, with the game's clock taken from the field counter of the core instead of the system clock, and puts everything that moves between its last two positions for the time of that field, as EDuke32 does on any monitor.

## If something is wrong

If the game stutters, the sound breaks up or something else is wrong, open the OSD while it happens and pick **Save Diagnostic Report**, the last line of the menu. The game keeps running; MiSTer's info box says the report is saved in `games/dnk/diagnostics/` on the SD card. Send that file (`EDuke32_<date>_<time>.zip`) with a few words on what went wrong.

The report has the setup (versions, the video and audio lines of `MiSTer.ini`, the OSD settings), how the last 60 seconds went, the game's log and a screenshot. Nothing else: no network settings, addresses, saved games or lists of your files.

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
| `eduke32/` | submodule: [EDuke32](https://voidpoint.io/terminx/eduke32) branch `mister`, with the MiSTer changes behind `MISTER_HYBRID` (`Common.mak`, `GNUmakefile`): the game's part in `source/duke3d/src/mister_port.cpp`, the engine's (video, clock, joystick) in `source/build/src/sdlayer.cpp` and `timer.cpp`, and the MIDI driver for the core's FM chip in `source/audiolib/src/driver_misterfm.cpp` |
| `package/` | files shipped in the release next to the binary (`danik_hybrid_launch.sh`, README), `games.txt`: the games and their menu entries, and `logos/`: each game's logo, shown while it starts |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm MISTER_HYBRID_CORE=EDuke32 MISTER_HYBRID_SET=EDuke32_DN3D <repository>/build/host/eduke32 -usecwd
  ```
- `MISTER=root@<address> tools/test_on_mister.sh DN3D` tries the build on a MiSTer next to what is installed there, without installing it: from `/tmp`, with the installed game's folder mirrored there (what the game writes stays in `/tmp`) and its own OSD settings. `DC`, `VACA`, `NW` for the add-ons, `list` and `nodata` for the core started by itself and without data, `log` for the game's log, `stop` to remove all of it again.
- `touch /tmp/eduke32_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (set `MISTER_HYBRID_CORE=EDuke32`, and `MISTER_HYBRID_SET` for a game's set name, e.g. `EDuke32_DC`). `/tmp/danik_hybrid_ports.log` shows what the launcher daemon did.

## Support

If you enjoy this project, you can support my work on [Patreon](https://www.patreon.com/itsdanik).

## Credits

- **[EDuke32](https://www.eduke32.com)** by Richard "TerminX" Gobeille, Evan "Hendricks266" Ramos and the EDuke32 contributors, which started from Jonathon Fowler's JFDuke3D.
- **Duke Nukem 3D** by 3D Realms Entertainment, who released its source code in 2003.
- **Build engine** by Ken Silverman.
- **Apogee Sound System** by James R. Dose, in EDuke32's audio library: its AdLib MIDI driver plays the music on the FM chip.
- **[JTOPL](https://github.com/jotego/jtopl)** by Jose Tejada (jotego): the FM chip in the core.
- **[GeneralUser GS](https://www.schristiancollins.com/generaluser.php)** by S. Christian Collins: the SoundFont of the core's MIDI synthesizer, which comes with the port, its licence next to it.
- **[SDL](https://libsdl.org)** by Sam Lantinga and contributors.
- **[MiSTer](https://github.com/MiSTer-devel)** by Sorgelig and the MiSTer-devel contributors: the framework and Template_MiSTer.
- **[MiSTer Frontier](https://github.com/MiSTerOrganize/MiSTer_Frontier)** by MiSTer Organize: thank you for the inspiration. Hybrid cores on the MiSTer, and the way their game is launched (a daemon that watches the loaded core and runs a script from its games folder), come from MiSTer Frontier. Our launcher is a separate implementation and does not need MiSTer Frontier installed.

This project and its maintainers are in no way associated with or endorsed by 3D Realms, Gearbox Software or any other holder of rights in Duke Nukem 3D. It does not include any game data.

## License

The top-level scripts, tools and documentation are licensed under the [GPL-3.0](LICENSE). The components keep their own licenses: EDuke32 is GPL-2.0 (`eduke32/package/common/gpl-2.0.txt`) and the Build engine in it is under Ken Silverman's Build license (`eduke32/package/common/buildlic.txt`: free of charge, no commercial use), the libraries it brings under their own (in `eduke32/source/`); the part of the shared framework the game is linked with (`hybrid/hps/`) is GPL-2.0-or-later, the rest of `hybrid/` GPL-3.0 except where its files say otherwise; SDL and the SDL drivers in `hybrid/sdl2` are zlib, the FPGA core and the MiSTer framework are GPL-2.0 (`core/LICENSE`, with the core's own sources GPL-2.0-or-later), JTOPL in it is GPL-3.0 (`hybrid/rtl/jtopl/LICENSE`).
