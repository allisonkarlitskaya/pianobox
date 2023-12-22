#!/bin/sh -eux

# Visit https://www.modartt.com/try?file=pianoteq_linux_trial_v813.7z
# no email address is actually required

test -e 'pianoteq_linux_trial_v813.7z' || cp -t . ~/Downloads/pianoteq_linux_trial_v813.7z
sha256sum -c checksums

case "$(uname -m)" in
    x86?64)
        arch='x86-64bit'
        ;;
    armv*)
        arch='x86-64bit'
        ;;
    aarch64)
        arch='x86-64bit'
        ;;
    *) 
        echo unknown arch
        exit 1
        ;;
esac

test -x 'Pianoteq 8' || 7za e pianoteq_linux_trial_v813.7z "Pianoteq 8/${arch}/Pianoteq 8"
podman image exists pianoteq || podman build -t pianoteq .


# NB: -v /dev/snd:/dev/snd isn't strictly required since Pianoteq can work via
# JACK, but in that case the MIDI input won't auto-connect.  Giving direct
# access to ALSA MIDI devices is a workaround.

podman run \
    --rm \
    --replace \
    --name=pianoteq \
    --detach \
    --net=none \
    --security-opt=label:disable \
    -v /dev/snd:/dev/snd \
    -v $XDG_RUNTIME_DIR/pipewire-0:/run/pipewire/pipewire-0 \
    pianoteq 
