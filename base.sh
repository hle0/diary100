#!/bin/bash

fn_exists() {
    test "$(type -t "$1")" = 'function'
    return $?
}

maybesource() {
    if [ -f "$1" ]; then
        echo "sourcing $1..."
        source "$1"
    elif [ -d "$1" ]; then
        for i in $(ls "$1"); do
            maybesource "$1/$i"
        done
    fi
}

audio_ext='ogg'

maybesource "$(pwd)/.diary100rc"
maybesource "~/.diary100rc"

fn_exists com-sig || com-sig() {
    echo "$(whoami)@$(hostname): $(date)"
}

beep() {
    tput bel
}

# check differences
chkdiff() {
    if [ $(git status --porcelain -uno | wc -l) -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

# ensure/existing commit
ecom() {
    if ! chkdiff; then
        echo "You don't have any changes to commit. Not committing."
    else
        git status && git commit -m "$(com-sig)"
    fi
}

# quick commit
qcom() {
    if chkdiff; then
        git status
        echo "You already have some changes that you haven't committed. Not adding any more files."
    else
        git add -A && ecom
    fi
}

LAST_DIARY100_FILE=""

# quick edit
qed() {
    nano "$1"

    maybe_add "$1"

    return $?
}

maybe_add() {
    if dialog --yesno "Commit changes to this file?" 0 0; then
	LAST_DIARY100_FILE="$1"
        git add "$LAST_DIARY100_FILE" && ecom
	return $?
    fi

    return 1
}

fn_exists audio_filename || audio_filename() {
    echo "audio/$(date -u +%F_%H_%M_%S)-$1.${audio_ext}"
}

qrec() {
    echo "Press Ctrl-C to stop"
    arecord -c 2 -r 96000 "$1.tmp"
    ffmpeg -loglevel error -f wav -i "$1.tmp" -af loudnorm "$1"
    rm "$1.tmp"
}

# quick play (autoexit)
qplay() {
    ffplay -autoexit "$1"
}

# long play
lplay() {
    vlc "file:///$(pwd)/$1"
}

# quick audio
qad() {
    newfilename="$(audio_filename "$1")"
    qrec "$newfilename"

    lplay "$newfilename"

    if ! maybe_add "$newfilename"; then
	rm "$newfilename"
	return 1
    fi
}
