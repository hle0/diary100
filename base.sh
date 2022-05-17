#!/bin/bash

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

maybesource "$(pwd)/.diary100rc"
maybesource "~/.diary100rc"

com-sig() {
    echo "$(whoami)@$(hostname): $(date)"
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

# quick edit
qed() {
    nano "$1"
    if dialog --yesno "Commit changes to this file?" 0 0; then
        git add "$1" && ecom
    fi
}

# quick audio
qad() {
    newfilename="audio/$(date -u +%F_%H_%M_%S)-$1.ogg"
    echo "Press Ctrl-C to stop"
    arecord -c 2 -r 96000 "$newfilename.tmp"
    ffmpeg -loglevel error -f wav -i "$newfilename.tmp" -af loudnorm "$newfilename"
    rm "$newfilename.tmp"

    vlc "file:///$(pwd)/$newfilename"
    if dialog --yesno "Commit changes to this file?" 0 0; then
        git add "$newfilename" && ecom
    else
	rm "$newfilename"
    fi
}
