import vm
import time
import re
import requests

def waitvm(ec2,id):
    # Wait for provisioning script to finish
    timeout=0
    createami=0
    vmdata=vm.queryvm(ec2,id)
    while timeout != 6:
        time.sleep(10)
        try:
            # Check VM worked by testing URL
            r=requests.get('http://'+vmdata['Reservations'][0]['Instances'][0]['PublicIpAddress'])
            # Check that web page has word we want
            if re.search('Steve',str(r.content)):
                print("Service is up and running")
                createami=1 # Enable AMI creation
            break
        except Exception as e:
            timeout=timeout+1 # Increase counter to stop script in case VM isn't working
            print("ERROR: "+str(e))
            print("Count: "+str(timeout))
            pass

    return createami
