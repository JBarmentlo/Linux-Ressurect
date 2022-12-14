#!/bin/bash

function check_aws_admin_connect() {
	local sts_id=$(aws sts get-caller-identity | cat)
	echo "$sts_id"

	if [[ $(echo $sts_id | grep "AWSReservedSSO_AWSAdministratorAccess" | wc -l) > 0 ]]; then 
		echo "All good"
		return 0
	else 
		echo "Log In Abnomaly"
		return 1
	fi
}

function exists_in_list() {
	LIST=$1
	DELIMITER=$2
	VALUE=$3
	[[ "$LIST" =~ ($DELIMITER|^)$VALUE($DELIMITER|$) ]]
}

function get_terraform_environment_name() { # service, env
	local service=$1
	local env=$2
	local env_name="default"
	declare -A fullNames=(["dev"]="development" ["ppd"]="preproduction" ["prd"]="production" ["shared"]="shared")

	if [[ $service == "network" ]]; then
		env_name="${fullNames[$env]}"

	elif exists_in_list "bucket, database, data-ingestor, sagemaker, account-backends, iam, secure-baseline" ", " $service; then
		env_name="$env"

	fi
	echo $env_name
	return 0
}

function terraform_select_or_create_workspace() { # workspace
	local workspace=$1

	if [[ $(terraform workspace list | grep $workspace | wc -l) == 0 ]]; then
		terraform workspace new $workspace
	else
		terraform workspace select $workspace
	fi
	return 0
}

function get_subfolder_name() { # service
	local service=$1

	if exists_in_list "account-backends, iam, network, secure-baseline" ", " $service; then
		echo "aichopen-aws-organization"

	elif exists_in_list "ecr, kafka" ", " $service; then
		echo "aichopen-aws-shared"

	elif exists_in_list "bucket, database, data-ingestor, sagemaker" ", " $service; then
		echo "aichopen-aws-workloads"
		
	fi
}

function export_aws_profile_env_var() { # service, env
	local service=$1
	local environment=$2
	
	if exists_in_list "account-backends, iam, network, secure-baseline" ", " $service; then
		export AWS_PROFILE="sysadmin+awstest.AWSAdministratorAccess"
		echo "export AWS_PROFILE=sysadmin+awstest.AWSAdministratorAccess"


	elif exists_in_list "ecr, kafka" ", " $service; then
		export AWS_PROFILE="Shared.AWSAdministratorAccess"
		echo "export AWS_PROFILE=Shared.AWSAdministratorAccess"


	elif exists_in_list "bucket, database, data-ingestor, sagemaker" ", " $service; then
		case $environment in
			dev)
				export AWS_PROFILE="Development.AWSAdministratorAccess"
				echo "export AWS_PROFILE=Development.AWSAdministratorAccess"
				;;

			ppd)
				export AWS_PROFILE="Preproduction.AWSAdministratorAccess"
				echo "export AWS_PROFILE=Preproduction.AWSAdministratorAccess"
				;;

			prd)
				export AWS_PROFILE="Production.AWSAdministratorAccess"
				echo "export AWS_PROFILE=Production.AWSAdministratorAccess"
				;;

		esac
	fi
	return 0
}

service=$1
environment=$2
terraform_env="$(get_terraform_environment_name "$service" "$environment")"
export_aws_profile_env_var "$service" "$environment"
echo "terraform env $terraform_env"
# terraform_select_or_create_workspace $terraform_env