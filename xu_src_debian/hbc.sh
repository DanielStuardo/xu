#!/bin/bash

#hbmk2 -lgpm -lhbsix -lhbct -lhbgd -lhbmisc -lhbclipsm -static xuc
#hbmk2 -lgpm -lhbnf -lhbsix -lhbct -lhbgd -lhbmisc -lhbclipsm -static xup
#-D_MAC64_
#/opt/harbour/bin/hbmk2  -lhbct -lhbmisc -blinker -nodebug  -D_MAC64_ -static xuc

if [ "$1" == "C" ]; then
   hbmk2 -lhbct -lhbmisc -D_LINUX64_ -static xu
   hbmk2 -lhbct -lhbmisc -D_LINUX64_ -static xuc
fi
hbmk2 -lhbct -static ed4xu

#/opt/harbour/bin/hbmk2   -lhbmisc -blinker -nodebug  -D_MAC64_ -static xuc
#/opt/harbour/bin/hbmk2   -lhbmisc -blinker -nodebug  -D_MAC64_ -static xup

#rm xu xuc
#mv xucr xuc
#mv xup xu

if [ "$1" == "C" ]; then
   sudo cp xu /usr/bin/xu
   sudo cp xuc /usr/bin/xuc
fi
sudo cp ed4xu /usr/bin/ed4xu

exit 0
