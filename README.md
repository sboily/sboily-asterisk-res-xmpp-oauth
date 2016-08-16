Google Voice support for XIVO with oauth2
=========================================

This provides an XMPP module for Asterisk with oauth support, which allows you to use
google voice with Asterisk.
It works with asterisk versions 13.x or later.

The source of the patches is in debian/patches directory. The res_xmpp.c is from asterisk vanilla 13.10.0 sources.

Tested with xivo 16.10. (Thanks to Ward Mundy to give me the informations and thank to Asterisk wiki for the documentation)

- http://nerdvittles.com
- https://wiki.asterisk.org/wiki/display/AST/Calling+using+Google

Requirements
------------
- Asterisk 13.x (or later) header files (http://asterisk.org)
- libiksemel libraries and header files
- libssl libraries and header files
- patch command

Installation
------------

    $ make patch
    $ make
    $ make install

To install the sample configuration file, issue the following command after
the 'make install' command:

    $ make samples

Load the module:

    $ systemctl restart asterisk
    $ asterisk -r
    $ modules load res_xmpp_oauth.so
    $ modules load chan_motif.so

Or add the module on your /etc/asterisk/modules.conf

Configuration
-------------

Please edit xmpp_oauth.conf and motif.conf in /etc/asterisk/. (see samples in configs)

You need to add icesupport=yes in /etc/asterisk/rtp.conf.

Add gv.conf in /etc/asterisk/extensions_extra.d/ and edit this file to add your DID in GV_DID variables.

    chown asterisk.www-data /etc/asterisk/extensions_extra.d/gv.conf
    chmod 660 /etc/asterisk/extensions_extra.d/gv.conf
    asterisk -rx "core reload"

Add your google voice DID in incoming call on the xivo web interface.

To do call with google voice add a custom trunk with:

 * name googlevoice
 * interface Motif/googlevoice
 * suffix @voice.google.com

In your outgoing call for google voice, use this custom trunk, please add the subroutine subr-google-voice.
