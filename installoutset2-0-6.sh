#!/bin/bash

sudo curl -L -o outset.pkg https://github.com/chilcote/outset/releases/download/v2.0.6/outset-2.0.6.pkg
sudo installer -pkg outset.pkg -target /
exit