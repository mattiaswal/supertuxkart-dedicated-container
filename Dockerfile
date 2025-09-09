FROM alpine:latest
RUN apk add xorg-server bash libdrm xf86-input-libinput mesa-dri-gallium mesa-egl xf86-video-modesetting mesa-utils mesa-gles
RUN apk add xinit xset xrandr xeyes xev
RUN apk add supertuxkart
RUN apk add supertuxkart --repository=http://dl-cdn.alpinelinux.org/alpine/edge/extra/
COPY start.sh /
COPY xinitrc /root/.xinitrc

ENTRYPOINT ["/start.sh"]
