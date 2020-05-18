#!/usr/bin/env python3

import boto3
import sys

def createvm(ec2,vmname,owner,sshkey,sgname,provfile):
    # Open the provisioning script file
    fh=open(provfile,"r")
    provdata=fh.read()
    fh.close()

    # Create the instance
    myinstance=ec2.create_instances(
	    ImageId='ami-06ce3edf0cff21f07',
	    InstanceType='t2.micro',
	    SecurityGroups=[sgname],
	    KeyName=sshkey['KeyName'],
            MinCount=1,
            MaxCount=1,
            UserData=provdata
    )

    for instance in myinstance:
        print("Instance ID: "+instance.id)
        ec2.create_tags(Resources=[instance.id], Tags=[
            {'Key':'Name', 'Value': vmname},
            {'Key':'Owner', 'Value': owner},
            {'Key':'StartDate', 'Value':'20200506'},
            {'Key':'EndDate', 'Value':'20200710'}
            ])

    # Get the Public IP
    instance.wait_until_running()
    return instance.id

def queryvm(ec2,id):

    ec2data=ec2.describe_instances(
        InstanceIds = [id]
    )

    print(ec2data['Reservations'][0]['Instances'][0]['PublicIpAddress'])
    return ec2data

if __name__ == "__main__":
    queryvm(sys.argv[1])
