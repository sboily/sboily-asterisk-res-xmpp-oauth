#
# Makefile for Asterisk xmpp oauth2 ressource
# Copyright (C) 2016, Sylvain Boily
#
# This program is free software, distributed under the terms of
# the GNU General Public License Version 3. See the COPYING file
# at the top of the source tree.
#

INSTALL = install
ASTETCDIR = $(INSTALL_PREFIX)/etc/asterisk
SAMPLEDIR = configs
SAMPLENAME = xmpp_oauth.conf.sample
CONFNAME = $(basename $(SAMPLENAME))

TARGET = res_xmpp_oauth.so
OBJECTS = res_xmpp.o
CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Winit-self -Wmissing-format-attribute \
          -Wformat=2 -g -fPIC -D_GNU_SOURCE -D'AST_MODULE="res_xmpp"' -D'AST_MODULE_SELF_SYM=__internal_res_xmpp_oauth_self'
LIBS += -liksemel
LDFLAGS = -Wall -shared

.PHONY: install clean

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@ $(LIBS)

%.o: %.c $(HEADERS)
	$(CC) -c $(CFLAGS) -o $@ $<

patch:
	patch -p0 < debian/patches/oauth_support.diff

install: $(TARGET)
	mkdir -p $(DESTDIR)/usr/lib/asterisk/modules
	install -m 644 $(TARGET) $(DESTDIR)/usr/lib/asterisk/modules/
	@echo " +-------- res_xmpp_oauth installed ---------+"
	@echo " +                                           +"
	@echo " + res_xmpp_oauth has successfully           +"
	@echo " + been installed.                           +"
	@echo " + If you would like to install the sample   +"
	@echo " + configuration file run:                   +"
	@echo " +                                           +"
	@echo " +              make samples                 +"
	@echo " +-------------------------------------------+"

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)
	patch -p0 -R < debian/patches/oauth_support.diff

samples:
	$(INSTALL) -m 644 $(SAMPLEDIR)/$(SAMPLENAME) $(DESTDIR)$(ASTETCDIR)/$(CONFNAME)
	@echo " ------- res_xmpp_oauth config installed ---------"
