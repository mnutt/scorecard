#!/bin/bash

# specviz-helper.sh
# Cuke
#
# Created by Michael Nutt on 10/12/09.
#
# Usage: spec-helper.sh project-directory named-pipe-path

source ~/.profile
source ~/.bashrc

cd $1
shift

SPEC_OPTS="-r rspec-cukeapp -f CukeappFormatter"
SPEC_PIPE=$1
shift

rake spec $@