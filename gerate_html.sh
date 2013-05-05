#!/bin/bash
## Gerate HTML DOCs 

## Clean folder _build
rm -rf _build/*

make html
rsync -av --delete-excluded  _build/html/ ../flask/
