#!/bin/bash

PATH=/usr/local/src/reposurgeon:$PATH

PROJECT_NAME=$1
CVS_SERVER=$2
AUTHOR_MAP_FILE="$PROJECT_NAME.map"

mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

repotool initialize $PROJECT_NAME <<< $'cvs\ngit\n'

#Comment current REMOTE_URL (svn for this version):
REMOTE_URL_ROW=`awk '$1 == "REMOTE_URL" { print NR }' Makefile`
sed -i "$REMOTE_URL_ROW s/REMOTE_URL/#REMOTE_URL/" Makefile

CVS_REMOTE_URL_ROW=$(awk '$1=="#REMOTE_URL"&&/cvs/{print NR}' Makefile) 
#Remove comments before #REMOTE_URL for cvs:
sed -i "$CVS_REMOTE_URL_ROW s/#REMOTE_URL/REMOTE_URL/" Makefile

#Update CVS_HOST
CURRENT_CVSSERVER=`awk '$1 == "CVS_HOST" { print $3 }' Makefile`

sed -i "s/$CURRENT_CVSSERVER/$CVS_SERVER/g" Makefile

make

if [ -f "$AUTHOR_MAP_FILE" ]
then
	echo "$AUTHOR_MAP_FILE found."
else
    echo "Authors map file $AUTHOR_MAP_FILE is not found. Generated one."
    make stubmap
    make
fi


bash

