#!/bin/bash
# Boxen jenv configuration globally
ver=$(echo $1 | sed s/././6)
export JENV_ROOT=/opt/boxen/jenv
/opt/boxen/jenv/bin/jenv global $ver
