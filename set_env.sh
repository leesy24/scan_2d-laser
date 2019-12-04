#!/bin/sh

[ ! -h libpcap.so.1 ] && ln -sf libpcap.so.1.8.1 libpcap.so.1
[ ! -h libssp.so.0 ] && ln -sf libssp.so.0.0.0 libssp.so.0

export LD_LIBRARY_PATH=/flash
