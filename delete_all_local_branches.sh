#!/bin/bash

read -p "Delete all local branches except for main ? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	git branch | grep -v "main" | xargs git branch -D
fi

