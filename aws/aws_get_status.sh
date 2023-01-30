#/bin/bash

echo "Gettings status for instance named: $1."

aws ec2 describe-instances --filters Name="tag:Name",Values=$1 --query 'Reservations[0].Instances[0].State.Name'

