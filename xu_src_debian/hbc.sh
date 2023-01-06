#!/bin/bash

#hbmk2 -lgpm -lhbsix -lhbct -lhbgd -lhbmisc -lhbclipsm -static xuc
#hbmk2 -lgpm -lhbnf -lhbsix -lhbct -lhbgd -lhbmisc -lhbclipsm -static xup
#-D_MAC64_
#/opt/harbour/bin/hbmk2  -lhbct -lhbmisc -blinker -nodebug  -D_MAC64_ -static xuc

if [ "$1" == "S" ]; then
   hbmk2 -lhbct -lhbmisc -D_LINUX64_ -static xu
   hbmk2 -lhbct -lhbmisc -lhbct -D_LINUX64_ -static xuc
   hbmk2 -lhbct -static laica
fi

if [ "$1" == "M" ]; then
   hbmk2 -lhbct -lhbmisc -D_LINUX64_ -static xu
fi
if [ "$1" == "C" ]; then
   echo "COMPILANDO XUC..."
   hbmk2 -lhbct -lhbmisc -lhbct -D_LINUX64_ -static xuc
fi
if [ "$1" == "V" ]; then
   hbmk2 -lhbct -lhbmisc -D_LINUX64_ -static xu
   hbmk2 -lhbct -lhbmisc -lhbct -D_LINUX64_ -static xuc
fi
if [ "$1" == "E" ]; then
   hbmk2 -lhbct -static laica
fi

#/opt/harbour/bin/hbmk2   -lhbmisc -blinker -nodebug  -D_MAC64_ -static xuc
#/opt/harbour/bin/hbmk2   -lhbmisc -blinker -nodebug  -D_MAC64_ -static xup

#rm xu xuc
#mv xucr xuc
#mv xup xu

#if [ "$1" == "S" ]; then
#   sudo cp xu /usr/bin/xu
#   sudo cp xuc /usr/bin/xuc
#   sudo cp laica /usr/bin/laica
#fi
if [ "$1" == "V" ]; then
   sudo cp xu /usr/bin/xu
   sudo cp xuc /usr/bin/xuc
fi
if [ "$1" == "C" ]; then
   echo "COMPIANDO XU Y XUC..."
   sudo cp xu /usr/bin/xu
   sudo cp xuc /usr/bin/xuc
   exit 0
fi
if [ "$1" == "M" ]; then
   sudo cp xu /usr/bin/xu
   exit 0
fi
if [ "$1" == "E" ]; then
   sudo cp laica /usr/bin/laica
   exit 0
fi

exit 0
