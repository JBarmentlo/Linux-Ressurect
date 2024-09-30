#!/usr/bin/bash
cat ~/.aws/config | grep '\[' | sed 's/profile //' | sed 's/\[//' | sed 's/\]//'
