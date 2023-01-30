#/bin/bash

if [ -z $1 ]
then
	user='all users'
else
	user="user $1"
fi

echo "Running sandboxes for $user"

aws ec2 describe-instances --filters Name="tag:Name",Values="sandbox*$1" Name=instance-state-name,Values=running --query '[Reservations[*].Instances[*].Tags[?Key==`Name`].Value] | [0][*][0][0]' | cat
