#!/bin/sh

ln -s libpcap.so.1.8.1 libpcap.so.1
ln -s libssp.so.0.0.0 libssp.so.0

export LD_LIBRARY_PATH=/flash
