#!/bin/bash

brctl addif $1 $2
ip link set $2 up
