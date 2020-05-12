#!/bin/bash

# Disassociate profile
associd=$(aws ec2 describe-iam-instance-profile-associations | jq -r '.IamInstanceProfileAssociations[] | select(.InstanceId == "'$1'") | .AssociationId')
profileid=$(aws ec2 describe-iam-instance-profile-associations | jq -r '.IamInstanceProfileAssociations[] | select(.InstanceId == "'$1'") | .IamInstanceProfile.Id')


# Get the instance profile Name
profname=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileId == "'$profileid'") | .InstanceProfileName')
rolenames=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileName == "'$profileid'") | .Roles[].RoleName')
arn=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileName == "'$profname'") | .Arn')

aws ec2 disassociate-iam-instance-profile --association-id $associd
# Delete instance
aws ec2 terminate-instances --instance-ids $1

# Get ARN of profile

# Detach role policy and role
for rolename in $rolenames
do
	# Remove role from instance profile
	aws iam remove-role-from-instance-profile --instance-profile-name $profname --role-name $rolename
	# Detach role policy
	for ap in $(aws iam list-attached-role-policies --role-name $rolename | jq -r '.AttachedPolicies[].PolicyArn')
	do
		aws iam detach-role-policy --role-name $rolename --policy-arn $ap
	done

	# Delete role
	aws iam delete-role --role-name $rolename
done

# Delete instance profile
aws iam delete-instance-profile --instance-profile-name $profname
