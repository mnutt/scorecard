#!/bin/sh

# kill_rspec.sh
# Cuke
#
# Created by Michael Nutt on 10/13/09.
# Copyright 2009 __MyCompanyName__. All rights reserved.


skill () 
{ 
	kill -9 `ps ax | grep $1 | grep -v grep | awk '{print $1}'`
}

skill bin/spec