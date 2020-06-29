#!/bin/sh

export VIRTUALENV="$1"
export ZIP_FILE="$1.zip"
export PYTHON_VERSION='python2.7'

virtualenv $VIRTUALENV
source $VIRTUALENV/bin/activate
# Pip install from a list of packages in a file, or just list them
pip install pip --upgrade --user
cp main.py $VIRTUALENV
cd $VIRTUALENV
python2.7 main.py
rm -rf $VIRTUALENV
