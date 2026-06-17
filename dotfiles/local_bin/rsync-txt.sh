#!/bin/sh
rsync -avz --delete rsync.rfc-editor.org::rfcs-text-only $HOME/rfc
