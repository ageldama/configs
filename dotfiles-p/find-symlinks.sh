#!/bin/sh
find -L . -xtype l -exec ls -l {} \; 
