#!/bin/bash

# Check if instance exists
if ! aws ec2 describe-instances --instance-id i-02b1e893221c6413f | jq -r '.Reservations[].Instances[] | select (.State.Name=="running")' | grep running >/dev/null 2>&1
then
	echo -n "Please enter the name of the Instance Profile: "
	read ipn
fi

if [[ -z $ipn ]]
then
	associd=$(aws ec2 describe-iam-instance-profile-associations | jq -r '.IamInstanceProfileAssociations[] | select(.InstanceId == "'$1'") | .AssociationId')
	profileid=$(aws ec2 describe-iam-instance-profile-associations | jq -r '.IamInstanceProfileAssociations[] | select(.InstanceId == "'$1'") | .IamInstanceProfile.Id')
else
	echo "Using Profile name $ipn"
	profileid=$(aws iam list-instance-profiles | jq -r '.InstanceProfiles[] | select (.InstanceProfileName == "'$ipn'") | .InstanceProfileId')
	echo "Profile ID $profileid"
fi

# Get the instance profile Name
profname=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileId == "'$profileid'") | .InstanceProfileName')
echo "Profile Name: $profname"
rolenames=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileId == "'$profileid'") | .Roles[].RoleName')
echo "Role names: $rolenames"
arn=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileName == "'$profname'") | .Arn')
echo "Profile instance ARN: $arn"

echo "Disassociating instance profile"
if [[ -z $ipn ]]
then
	# Disassociate profile
	aws ec2 disassociate-iam-instance-profile --association-id $associd
	# Delete instance
	echo "Deleting instance"
	aws ec2 terminate-instances --instance-ids $1
fi

# Get ARN of profile

# Detach role policy and role
for rolename in $rolenames
do
	# Remove role from instance profile
	echo "Removing role from instance profile"
	aws iam remove-role-from-instance-profile --instance-profile-name $profname --role-name $rolename
	# Detach role policy
	for ap in $(aws iam list-attached-role-policies --role-name $rolename | jq -r '.AttachedPolicies[].PolicyArn')
	do
		echo "Detaching role and policy"
		aws iam detach-role-policy --role-name $rolename --policy-arn $ap
	done

	# Delete role
	echo "Deleting role"
	aws iam delete-role --role-name $rolename
done

# Delete instance profile
echo "Deleting instance profile"
aws iam delete-instance-profile --instance-profile-name $profname
