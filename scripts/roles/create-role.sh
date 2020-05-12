#!/bin/bash


# Create a new role to assign to your VMs
aws iam create-role --role-name steveSuperRole \
    --assume-role-policy-document file://allow.json \
    --region eu-west-1

# Attach existing policy to role
aws iam attach-role-policy --role-name steveSuperRole \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess \
    --region eu-west-1

# Create instance profile to associate to VMs
aws iam create-instance-profile --instance-profile-name steveVMProfile
aws iam add-role-to-instance-profile --instance-profile-name=steveVMProfile \
    --role-name steveSuperRole

# Get the instance profile Arn
arn=$(aws iam list-instance-profiles |jq -r '.InstanceProfiles[] | select (.InstanceProfileName == "steveVMProfile") | .Arn')

# Create VM and assign role
instance=$(aws ec2 run-instances --count 1 --image-id ami-026dae6ae692e19e1 \
    --instance-type t2.micro --region eu-west-1 \
    --key-name steveshillingacademyie --security-groups AcademySG \
    --tag-specifications '[{"ResourceType": "instance","Tags": [{"Key": "Name", "Value": "SteveVM"}]}]' )

# Instance ID
ID=$(echo "$instance" | jq -r '.Instances[].InstanceId')
echo "$ID"

until aws ec2 describe-instances --instance-id $ID | jq -r '.Reservations[].Instances[].State.Name' | grep running
do
	sleep 15
done

# Associate role to VM
aws ec2 associate-iam-instance-profile --iam-instance-profile '{"Arn": "'$arn'", "Name": "steveVMProfile"}' \
          --instance-id $ID

echo "Public IP: $(aws ec2 describe-instances --instance-id $ID | jq -r '.Reservations[].Instances[].PublicIpAddress')"

