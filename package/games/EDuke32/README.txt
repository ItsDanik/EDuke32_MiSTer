EDuke32 for MiSTer - Duke Nukem 3D and its add-ons as a hybrid port
====================================================================

The game (EDuke32, the source port of 3D Realms' Duke Nukem 3D) runs on
the MiSTer's ARM CPU; the EDuke32 FPGA core provides native 15kHz video
(CRT, VGA and HDMI) at 320x200, 640x200, 320x240 or 640x240, audio, a MIDI
synthesizer and an FM chip for the music, and input with rumble.

Disclaimer: AI is being used to speed up development of this project.

Requirements
  - danik_hybrid_ports, the launcher that comes with this release
    (Scripts/danik_hybrid_ports.sh): run it ONCE from the MiSTer's Scripts
    menu. It starts the game whenever its menu entry is loaded, keeps
    running after a reboot, and serves all our hybrid ports; its screen
    picks which ports and games to have, and can keep them up to date
    through update_all. It replaces danik_hybrid_cores, the launcher before
    it, and moves ports installed the old way into the new folders by
    itself. Without it the core says "Game not running".
  - Game data. It is not included: DUKE3D.GRP of Duke Nukem 3D, version
    1.3D or the Atomic Edition (1.4 or 1.5: from the original CD, Megaton
    Edition or the GOG release), or of the shareware version. The add-ons
    are optional and need the full game's DUKE3D.GRP as well: Duke It Out
    in D.C. (DUKEDC.GRP) and Life's a Beach (VACATION.GRP) of the same
    version as it (1.3D or Atomic), Nuclear Winter (NWINTER.GRP) with the
    Atomic Edition.

Install
  With update_all (Downloader 2.4 or newer): copy
  downloader_danik_hybrid_ports.ini to /media/fat/, run update_all, run
  danik_hybrid_ports from the Scripts menu, tick the games, X: Apply.
  By hand:
  1. Extract the zip to the root of the SD card (/media/fat): _Other/,
     games/dnk/EDuke32/, games/dnk/SoundFonts/, Scripts/ and
     downloader_danik_hybrid_ports.ini (with which update_all keeps the
     ports up to date from then on).
  2. Copy EVERYTHING in the game's folder (the one with DUKE3D.GRP) to
     /media/fat/games/dnk/EDuke32/, with its folders as they are, and
     leave nothing out (files the port does not use do no harm). The port
     finds in it:
       DUKE3D.GRP
       optional: DUKEDC.GRP, VACATION.GRP and NWINTER.GRP, there or in
         the folders addons/dc, addons/vacation and addons/nw.
     The whole "gameroot" folder of Megaton Edition can be copied as it
     is: the add-ons are found in its "addons".
  3. Run danik_hybrid_ports from the Scripts menu, if you have not done so
     before (see Requirements).
  4. Load the game from the Other menu, e.g. dnk-Duke Nukem 3D.
  The game data can go on a USB drive instead, into the same folder there
  (/media/usb0/games/dnk/EDuke32/): the game looks for it there first, and
  then keeps its settings and saved games there as well. Everything else
  stays on the SD card.

The game files are known by their contents, whatever their names. The menu
entry of Duke Nukem 3D starts the shareware when the full game is not
there. When a game's files are missing, the core says which files to copy
where. Each game keeps its own OSD settings and button mappings. The core
file itself (_Other/dnk/dnk-EDuke32_*.rbf, or from Recent) lists the games
that are there to pick from, other add-ons the game knows among them
(Duke!ZONE II, Penthouse Paradise); quitting a game then returns to the
list.

OSD options
  Aspect ratio, Scale, Scandoubler Fx, Stereo Mix as in other cores.
  FPS Counter   shows the pictures per second in the top left corner.
  HDMI Only     Yes if no CRT is connected: resolutions of 640x400 and more
                are then progressive instead of interlaced, and the analog
                output is switched off while one is shown, so that a 15kHz
                screen can never get such a signal. This game has no such
                resolution, so nothing changes. Not there with
                direct_video=1.
  CRT Options   for a 15kHz screen: Horizontal Size, Horizontal Pos and
                Vertical Pos fit the picture to it. The pixels stay as they
                are; HDMI is not affected. The size is for the game's
                picture: the core's own, with its messages, keeps its
                width. Not there with forced_scandoubler=1. HUD (Bottom)
                and HUD (Top): in the 240-line resolutions, how many lines
                the HUD sits away from the bottom and the top edge of the
                screen, 0 to 24 (0 by default), so that a CRT's overscan
                does not hide it. The bottom margin moves the status bar
                (or the mini HUD) and the weapon, the top one the messages,
                the level's name and the frag bar. Both greyed out at 200
                lines.
  Resolution    what the game renders and the core puts out, always at
                15kHz: 320x200 (default, as the original), 640x200, 320x240
                or 640x240. 640 across is twice the detail in the same
                place. 240 lines are square pixels at 320 across: the view
                fills all of them, from the top edge to the bottom one,
                with the HUD drawn over it at the HUD margins; the menus
                and pictures keep their 200 lines in the middle. The
                artwork is never stretched. Applies at once in the game and
                its menu. The game's own video mode menu is not there.
  L. Stick Sensitivity, R. Stick Sensitivity
                how fast the gamepad's left stick (walk, strafe) and right
                stick (turn, look) move the player, 25% to 300%, on top of
                the sensitivity in the game's own menu. Apply at once.
  Limit Vertical Look
                how far the view tilts up and down. The Build engine shifts
                the picture instead of turning the camera, which distorts
                it the further you look. On (default) leaves half of the
                game's own range in both directions, Off is the whole range.
  Rumble        the gamepad's rumble when you take damage, fire, land hard
                or something blows up nearby: On (default) as the game has
                it, Strong twice as strong, Off.
  Music         the game's music, which is MIDI: MIDI (default), played by
                the core's synthesizer with a SoundFont, or by an MT32-pi
                when one is connected and on; FM chip: on the FM chip, as
                an AdLib or Sound Blaster card played it. SoundFont:
                Default is GeneralUser GS, which comes with the port
                (games/dnk/SoundFonts/GeneralUser-GS.sf2); 1 to 7 are your
                own .sf2 files in that folder. A SoundFont that is missing,
                damaged or too big (over 64 MB) is said in the info box,
                and the music goes to the FM chip.
  MT32-pi       only there while an MT32-pi answers on the user port.
  Cheats        God Mode, No Clipping, Show Full Map and No Monsters stay
                on until switched off. Give Everything (every weapon with
                full ammo, armor, the inventory items and all keys), Give
                Weapons and Give Keys do it once each time; Next Level: the
                level counts as completed and the next one starts. None of
                them at Damn I'm Good, nor in a demo or a user map.

Controls
  Keyboard and mouse:
    W, S                                Walk forward, back
    A, D                                Sidestep left, right
    Mouse (or left, right)              Turn; up and down looks
    Left mouse button (or right Ctrl)   Fire
    E                                   Open, use
    Space                               Jump
    Left Ctrl (C: on and off)           Crouch
    Shift                               Run (Caps Lock: always run)
    1 - 0                               Weapons
    Mouse wheel, ' and ;                Next, previous weapon
    Q                                   Quick kick
    Enter, [ and ]                      Use the inventory item, previous
                                        and next item
    M, R, N, J, H                       Medkit, steroids, night vision,
                                        jetpack, holoduke
    Page Up, Page Down, Home, End       Look and aim up and down
    Tab                                 Map
    F6, F9                              Quick save, quick load
    Esc                                 Menu
    These are EDuke32's own keys. "Control Setup" in the game's menu
    changes keys and mouse; they are saved in settings.cfg.
  Gamepad (default mapping):
    Left stick                          Walk and strafe
    Right stick                         Turn, look up and down
    D-pad                               Walk and turn
    R (RB / R1), or R2                  Fire
    B (Xbox A / PlayStation Cross)      Open, use
    A (Xbox B / PlayStation Circle)     Jump
    L (LB / L1)                         Crouch
    Y (Xbox X / PlayStation Square)     Next weapon
    X (Xbox Y / PlayStation Triangle)   Use the inventory item. Held, with
                                        the d-pad left or right: previous
                                        or next item (let go without the
                                        d-pad to use one)
    L2, R3 (right stick click)          Quick kick
    L3 (left stick click)               Run, on and off
    Select                              Map
    Start                               Menu
  In the game's menus the buttons that confirm and go back are the ones of
  your MiSTer menu, whatever they do in the game: its Menu OK / Menu Back if
  you set them in "Define joystick buttons", else its A / B. A controller
  never set up in MiSTer confirms and goes back as on its console: Cross /
  Circle on PlayStation, A / B on Xbox and on Nintendo.
  Change the buttons in the OSD under "Define EDuke32 buttons". "Menu OK"
  and "Menu Back" there are only needed for a spare button without a game
  function. While the OSD is open, the game gets no input. The game's own
  button settings for the gamepad are set again at every start.

Music
  Duke Nukem 3D's music is MIDI. With Music on MIDI (the default) a
  SoundFont synthesizer in the FPGA core plays it, or an MT32-pi when one
  is connected; with Music on FM chip it plays as an AdLib or Sound Blaster
  card did, on a YM3812 in the core, with the game's own instruments. The
  game's Music volume sets its level. It needs the core (.rbf) of the same
  release.

If something is wrong
  If the game stutters, the sound breaks up or something else is wrong,
  open the OSD while it happens and pick Save Diagnostic Report, the last
  line of the menu. The game keeps running; MiSTer's info box says the
  report is saved in games/dnk/diagnostics/. Send that file
  (EDuke32_<date>_<time>.zip) with a few words on what went wrong. It has
  the setup, how the last 60 seconds went, the game's log and a
  screenshot; no network settings, addresses, saved games or lists of
  your files.

Files
  /media/fat/games/dnk/EDuke32/eduke32.cfg, settings.cfg   settings
  /media/fat/games/dnk/EDuke32/save*.esv   saved games of Duke Nukem 3D,
      those of the add-ons in the folders DC, VACA and NW there
      (all on the USB drive, if the game data is there)
  /media/fat/logs/dnk/EDuke32/eduke32.log   the game's log
  /media/fat/games/dnk/SoundFonts/GeneralUser-GS.sf2   the SoundFont,
      shared with the other ports with MIDI music

Credits
  EDuke32 by Richard "TerminX" Gobeille, Evan "Hendricks266" Ramos and the
  EDuke32 contributors (https://www.eduke32.com), which started from
  Jonathon Fowler's JFDuke3D.
  Duke Nukem 3D by 3D Realms Entertainment.
  Build engine by Ken Silverman.
  // "Build Engine & Tools" Copyright (c) 1993-1997 Ken Silverman
  // Ken Silverman's official web site: "http://www.advsys.net/ken"
  // See the included license file "BUILDLIC.TXT" for license info.
  Apogee Sound System by James R. Dose, in EDuke32's audio library: its
  AdLib MIDI driver plays the music on the FM chip.
  JTOPL by Jose Tejada (jotego), https://github.com/jotego/jtopl: the FM
  chip in the core.
  GeneralUser GS by S. Christian Collins (the SoundFont,
  https://www.schristiancollins.com/generaluser.php; its licence in
  games/dnk/SoundFonts/GeneralUser-GS-LICENSE.txt).
  SDL by Sam Lantinga and contributors.
  MiSTer by Sorgelig and the MiSTer-devel contributors.
  MiSTer Frontier by MiSTer Organize
  (https://github.com/MiSTerOrganize/MiSTer_Frontier): thank you for the
  inspiration. Hybrid cores on the MiSTer, and the way their game is
  launched, come from MiSTer Frontier. Our launcher is a separate
  implementation and does not need MiSTer Frontier installed.

This project and its maintainers are in no way associated with or endorsed
by 3D Realms, Gearbox Software or any other holder of rights in Duke Nukem
3D. It does not include any game data.

License
  EDuke32: GPL-2.0 (LICENSE-eduke32.txt)
  The Build engine in it: Ken Silverman's Build license
  (BUILDLIC.TXT), free of charge, no commercial use
  SDL: zlib (LICENSE-sdl.txt)
  The launcher scripts: GPL-3.0 (LICENSE-gpl3.txt)
  The FPGA core: GPL-2.0, the FM chip in it (JTOPL): GPL-3.0
  Source: https://github.com/ItsDanik/EDuke32_MiSTer
          https://github.com/ItsDanik/Hybrid_MiSTer (launcher, framework)
