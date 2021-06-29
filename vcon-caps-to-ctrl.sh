#!/bin/sh
sudo dumpkeys|sed 's/Caps_Lock/Control/' |sudo loadkeys 

