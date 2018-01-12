#!/bin/bash
#
# file is ruled by puppet. resistance is futile
#
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

HOMEDIR=/etc/sci/gpg

# XXX not using -s here because the key generation may be long
if [ -f $HOMEDIR/secring.gpg ]; then
  echo You already have keys is $HOMEDIR. Aborting.
  exit 1
fi
chmod 700 $HOMEDIR

# we need entropie for /dev/random, only keyboard, mouse and the disk
# controller driver call the /dev/random-functions 
# ...but sha256sum too:
# http://aaronhawley.livejournal.com/10807.html
# but computers are too fast nowdays...
rngd -r /dev/urandom

gpg --homedir $HOMEDIR --no-options --batch --gen-key $HOMEDIR/sci-key-input


if [ $? -eq 0 ]; then
  gpg --homedir /etc/sci/gpg/ --export >$HOMEDIR/sci.pub
  echo Key exported to puppet
  killall rngd
  exit 0
else
  echo GPG Key generation aborted
  killall rngd
  exit 1
fi
