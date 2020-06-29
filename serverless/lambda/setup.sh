#!/bin/sh

export VIRTUALENV="$1"
export ZIP_FILE="$1.zip"
export PYTHON_VERSION='python2.7'

virtualenv $VIRTUALENV
source $VIRTUALENV/bin/activate
# Pip install from a list of packages in a file, or just list them
pip install pip --upgrade --user
cp main.py $VIRTUALENV
cd $VIRTUALENV/lib/$PYTHON_VERSION/site-packages/
zip -9r ../../../../$ZIP_FILE *
cd ../../../../
zip -g $ZIP_FILE main.py

# Clean up
rm -fr $VIRTUALENV
#deactivate
