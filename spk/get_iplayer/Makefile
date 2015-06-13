SPK_NAME = get_iplayer
SPK_VERS = 2.94
SPK_REV = 1
SPK_ICON = src/getiplayer.png

DEPENDS = cross/busybox cross/rtmpdump cross/$(SPK_NAME)
SPK_DEPENDS = "Perl"

MAINTAINER = SynoCommunity
DESCRIPTION = get_iplayer allows you to search, index and record/stream BBC iPlayer radio and TV.
ADMIN_PORT = 1935
RELOAD_UI = yes
DISPLAY_NAME = get_iplayer
BETA = 1

HOMEPAGE = http://www.infradead.org/get_iplayer/html/get_iplayer.html
LICENSE  = GPLv3+

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = get_iplayer_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: get_iplayer_extra_install
get_iplayer_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
