FROM alpine:latest
RUN true \
  && sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories \
  && apk upgrade --update-cache --available \
  #
  # Add font, otherwise firefox draws garbage "tofu".
  # Noto is a Google-created open source font (Open Font License)
  && apk add --no-cache font-noto \
  #
  # It seems only ESR is in alpine's package list.
  # I'll not custom-build Firefox at this time.
  && apk add --no-cache firefox-esr \
  #
  # Firefox doesn't like running as root, so add a user.
  # Also, X11 checks the user ID of who's connecting.
  # The user ID (not user name) here should match the
  # user ID of your host machine. Setting the user ID
  # would be done here, but I leave that as an exercise
  # for you to figure out.
  && adduser -s $(which firefox) -D firefox \
  && true

# Bind-mount /tmp/.X11-unix:/tmp/.X11-unix
# Otherwise, you will get various errors.
# Some are described below.
#
# > No protocol specified
# > Error: cannot open display: :0
# The above error indicates that your user was denied permission to connect to the unix socket.
#
# > Running Firefox as root in a regular user's session is not supported.  ($HOME is /home/firefox which is owned by firefox.)
# You tried to start Firefox under the container's root user.
#
# > process 234: D-Bus library appears to be incorrectly set up; failed to read machine uuid: Failed to open "/etc/machine-id": No such file or directory
# You need to generate a new machine ID. It must be 16 random hexadecimal characters.
#
# Good luck!
#
WORKDIR /home/firefox
ENV DISPLAY=:0
ENV HOME=/home/firefox
CMD true \
  && head -c 16 /dev/urandom \
    | xxd -g 16 -c 16 \
    | cut -d ' ' -f 2 > /etc/machine-id \
&& su firefox -- --no-remote

