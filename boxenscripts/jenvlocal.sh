#!/bin/bash
# boxen jenv configuration locally
ver=$(echo $1 | sed s/././6)
sudo chown -R ${USER}:staff $2
export JENV_ROOT=/opt/boxen/jenv
cd $2 && sudo /opt/boxen/jenv/bin/jenv local $ver
#sudo /opt/boxen/jenv/bin/jenv local $ver $2
