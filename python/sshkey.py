#!/usr/bin/env python3
import os
import stat

def createkey(ec2,keyname,description):
    # Check if Key exists
    newkey=0
    try:
        sshkey=ec2.describe_key_pairs(
                KeyNames = [keyname]
        )
    except:
        newkey=1

    if newkey == 1:
        # Create SSH Key
        sshkey=ec2.create_key_pair(
                KeyName=keyname,
                TagSpecifications=[
                    {
                        'ResourceType': 'key-pair',
                        'Tags': [
                            {
                                'Key': 'Name',
                                'Value': description
                            }
                        ]
                    }
                ]
        )
        print("SSH Key created in AWS")

        # Save the SSH Key
        filename=keyname+".pem"
        sshfh = open(filename, "w")
        sshfh.write(sshkey['KeyMaterial'])
        sshfh.close()
        os.chmod(filename, stat.S_IRWXU )
        chkfh=open(filename,"r")
        chkdata=chkfh.read()
        chkfh.close()
        print("SSH Key saved to disk")

    return sshkey
