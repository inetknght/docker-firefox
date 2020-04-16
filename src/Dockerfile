FROM alpine:latest
RUN true \
  && sed -e 's/v[[:digit:]]\+\.[[:digit:]]\+/edge/g' /etc/apk/repositories \
   | tee -a /etc/apk/repositories \
  && apk upgrade --update-cache --available \
  #
  # Add font, otherwise firefox draws garbage "tofu".
  # Noto is a Google-created open source font (Open Font License)
  && apk add --no-cache font-noto ghostscript-fonts \
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
  && touch /etc/machine-id \
  && chmod 666 /etc/machine-id \
  && mkdir -p /etc/firefox \
  && { true \
    && echo 'pref("beacon.enabled", false);' \
    && echo 'pref("browser.bookmarks.restore_default_bookmarks", false);' \
    && echo 'pref("browser.download.manager.alertOnEXEOpen", true);' \
    && echo 'pref("browser.formfill.enable", false);' \
    && echo 'pref("browser.newtabpage.activity-stream.default.sites", "");' \
    && echo 'pref("browser.newtabpage.activity-stream.discoverystream.endpoints", "");' \
    && echo 'pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);' \
    && echo 'pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);' \
    && echo 'pref("browser.newtabpage.activity-stream.feeds.snippets", false);' \
    && echo 'pref("browser.newtabpage.activity-stream.feeds.topsites", false);' \
    && echo 'pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);' \
    && echo 'pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);' \
    && echo 'pref("camera.control.face_detection.enabled", false);' \
    && echo 'pref("canvas.capturestream.enabled", false);' \
    && echo 'pref("canvas.filters.enabled", false);' \
    && echo 'pref("captivedetect.canonicalURL", "https://captiveportal.inetknght/firefox:captivedetect.canonicalURL");' \
    && echo 'pref("datareporting.policy.firstRunURL", "https://firstrun.inetknght/firefox:datareporting.policy.firstRunURL");' \
    && echo 'pref("device.sensors.ambientLight.enabled", false);' \
    && echo 'pref("device.sensors.enabled", false);' \
    && echo 'pref("device.sensors.motion.enabled", false);' \
    && echo 'pref("device.sensors.proximity.enabled", false);' \
    && echo 'pref("device.sensors.test.events", false);' \
    && echo 'pref("device.storage.enabled", false);' \
    && echo 'pref("dom.battery.enabled", false);' \
    && echo 'pref("dom.disable_window_move_resize", true);' \
    && echo 'pref("dom.disable_window_open_feature.close", true);' \
    && echo 'pref("dom.disable_window_open_feature.menubar", true);' \
    && echo 'pref("dom.disable_window_open_feature.minimizable", true);' \
    && echo 'pref("dom.disable_window_open_feature.personalbar", true);' \
    && echo 'pref("dom.disable_window_open_feature.titlebar", true);' \
    && echo 'pref("dom.disable_window_open_feature.toolbar", true);' \
    && echo 'pref("dom.event.clipboardevents.enabled", false);' \
    && echo 'pref("dom.events.asyncClipboard", false);' \
    && echo 'pref("dom.maxHardwareConcurrency", 1);' \
    && echo 'pref("dom.udpsocket.enabled", false);' \
    && echo 'pref("dom.vr.enabled", false);' \
    && echo 'pref("dom.vr.oculus.enabled", false);' \
    && echo 'pref("dom.webnotifications.serviceworker.enabled", false);' \
    && echo 'pref("dom.workers.maxPerDomain", 0);' \
    && echo 'pref("experiments.activeExperiment", false);' \
    && echo 'pref("extensions.formautofill.addresses.enabled", false);' \
    && echo 'pref("extensions.formautofill.firstTimeUse", false);' \
    && echo 'pref("extensions.pocket.api", "0.0.0.0 disabled");' \
    && echo 'pref("extensions.pocket.enabled", false);' \
    && echo 'pref("extensions.pocket.oAuthConsumerKey", "none");' \
    && echo 'pref("extensions.pocket.site", "0.0.0.0 disabled");' \
    && echo 'pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket", false);' \
    && echo 'pref("geo.enabled", false);' \
    && echo 'pref("javascript.options.wasm", false);' \
    && echo 'pref("network.dns.disablePrefetch", true);' \
  && true; } > /etc/firefox/syspref.js \
  && chmod 666 /etc/firefox/syspref.js \
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
  && { true \
    && echo 'pref("browser.newtabpage.activity-stream.impressionId", "{00000000-0000-0000-0000-000000000000}");' \
    && echo 'pref("dom.push.userAgentID", "00000000000000000000000000000000");' \
    && echo 'pref("permissions.eventTelemetry.salt", "{00000000-0000-0000-0000-000000000000}");' \
    && echo 'pref("toolkit.telemetry.cachedClientID", "00000000-0000-0000-0000-000000000000");' \
    && echo 'pref("webgl.disabled", true);' \
  && true; } >> /etc/firefox/syspref.js \
  && su firefox -- --no-remote --new-session
