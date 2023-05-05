#/bin/bash
aws ec2 describe-instances --filters Name="tag:Name",Values=$1 Name="instance-state-name",Values=running --query 'Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName' | cat | tr -d '"'
