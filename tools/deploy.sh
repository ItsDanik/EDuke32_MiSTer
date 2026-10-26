#!/bin/sh
# Package the build and copy it to a MiSTer over ssh, in the layout of the
# hybrid ports. The core is not (re)loaded: load a game of EDuke32 from the
# Other menu afterwards. Run Scripts/danik_hybrid_ports.sh on the MiSTer
# once to set up the launcher. A MiSTer that has EDuke32 in the old layout
# (games/EDuke32/) gets it moved by the launcher (version 3) once this is
# there. Each copy shows how far it is (pv: the percentage and the time
# left), or without pv the name of every file.
# usage: MISTER=root@<address> tools/deploy.sh
set -e
cd "$(dirname "$0")/.."
HOST=${MISTER:?set MISTER=root@<address of the MiSTer>}

# put <file> <path on the MiSTer>
put() {
    if command -v pv > /dev/null; then
        pv -f -i 0.5 -N "$(basename "$1")" "$1" | ssh "$HOST" "cat > $2"
    else
        echo "  $(basename "$1")"
        scp -q "$1" "$HOST:$2"
    fi
}
# send <folder> <folder on the MiSTer> [tar options]: what is in it
send() {
    src=$1 dst=$2
    shift 2
    if command -v pv > /dev/null; then
        size=$(cd "$src" && tar cf - "$@" . | wc -c)
        (cd "$src" && tar cf - "$@" .) | pv -f -i 0.5 -s "$size" -N "${dst#/media/fat/}" |
            ssh "$HOST" "tar xf - --no-same-owner -C $dst"
    else
        echo "${dst#/media/fat/}:"
        (cd "$src" && tar cf - "$@" .) | ssh "$HOST" "tar xvf - --no-same-owner -C $dst"
    fi
}

echo "Packaging..."
./package.sh > /dev/null
OUT=dist/EDuke32_$(date +%Y%m%d)
G=/media/fat/games/dnk/EDuke32
echo "Copying $OUT to $HOST..."
ssh "$HOST" "mkdir -p $G /media/fat/_Other/dnk /media/fat/Scripts/.danik_hybrid_ports && rm -f /media/fat/_Other/dnk/dnk-EDuke32_*.rbf"
# a running game keeps its binary busy: copy next to it, then swap
# (scp would copy into a folder of that name, if something left one behind)
ssh "$HOST" "rm -rf $G/EDuke32.new"
put "$OUT/games/dnk/EDuke32/EDuke32" "$G/EDuke32.new"
ssh "$HOST" "mv -f $G/EDuke32.new $G/EDuke32"
# everything else of the package (user files on the MiSTer are left alone)
send "$OUT/games/dnk/EDuke32" "$G" --exclude=./EDuke32
send "$OUT/Scripts" /media/fat/Scripts
send "$OUT/_Other" /media/fat/_Other
ssh "$HOST" "chmod +x $G/EDuke32 $G/*.sh /media/fat/Scripts/danik_hybrid_ports.sh; ls -la $G /media/fat/_Other/dnk/dnk-EDuke32_*.rbf /media/fat/_Other/dnk-*.mgl"
echo "Deployed."
