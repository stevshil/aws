#!/usr/bin/env python3
def createsg(ec2,grpName,vpcid):
    # Check if security group exists
    try:
        sgdata=ec2.describe_security_groups(
            GroupNames=[grpName]
        )

    except:
        # Create Security Group
        secgrp=ec2.create_security_group(
                GroupName=grpName,
                Description=grpName+' Automated Python Security Group',
                VpcId=vpcid
        )
        print("Security Group "+str(secgrp['GroupId']))

        fwrules=ec2.authorize_security_group_ingress(
                GroupId=secgrp['GroupId'],
                IpPermissions=[
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': 22,
                        'ToPort': 22,
                        'IpRanges': [{'CidrIp': '82.24.122.149/32'}]
                    },
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': 80,
                        'ToPort': 80,
                        'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
                    },
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': 443,
                        'ToPort': 443,
                        'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
                    },
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': 3306,
                        'ToPort': 3306,
                        'IpRanges': [{'CidrIp': '82.24.122.149/32'}]
                    }
                ]
        )
        print("Firewall rules applied to security group")

        # Get Security Group Detail
        sgdata=ec2.describe_security_groups(
                GroupIds=[secgrp['GroupId']]
        )

    return sgdata
