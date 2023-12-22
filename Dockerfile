FROM fedora:latest

RUN dnf install -y alsa-lib freetype pipewire-jack-audio-connection-kit && dnf clean all

COPY ["Pianoteq 8", "/usr/local/bin"]
COPY Pianoteq.prefs /usr/local/etc/Pianoteq.prefs

ENV PIPEWIRE_RUNTIME_DIR=/run/pipewire
CMD ["Pianoteq 8", "--prefs", "/usr/local/etc/Pianoteq.prefs", "--headless"]
