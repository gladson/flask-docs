#!/bin/bash


## Gerate HTML DOCs 

## Clean folder _build
if [ -d "_build" ]
then
	rm -rf _build/*
	make html
else
	mkdir _build
	make html
fi


if [ -d "../flash" ]
then
	rsync -av --delete-excluded  _build/html/ ../flask/
else
	mkdir ../flask
        rsync -av --delete-excluded  _build/html/ ../flask/
fi
