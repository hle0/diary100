#!/bin/bash

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
    newfilename="audio/$(date +%s)-$1.mp3"
    echo "Press q to stop"
    ffmpeg -loglevel error -use_wallclock_as_timestamps 1 -f alsa -i hw:1 "$newfilename"

    ffplay -loglevel error "$newfilename" &
    if dialog --yesno "Commit changes to this file?" 0 0; then
        git add "$newfilename" && ecom
    fi
    kill -INT $!
}