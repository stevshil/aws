import os

def clean(client,id,sgdata,keyname):
    # Terminate instance regardless
    client.terminate_instances(
        InstanceIds=[id]
    )
    print("Terminating instance "+id)
    waiter = client.get_waiter('instance_terminated')
    waiter.wait(InstanceIds=[id])

    client.delete_security_group(
        GroupId=sgdata['SecurityGroups'][0]['GroupId']
    )
    print("Removed security group "+sgdata['SecurityGroups'][0]['GroupId'])

    client.delete_key_pair(
        KeyName=keyname
    )
    print("Removed SSH Key")
    os.remove(keyname+".pem")
