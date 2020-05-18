import time

def createimg(ec2,id,description,name,createami):
    if createami == 1:
        # Publish AMI
        print("Publishing AMI")
        imgid=ec2.create_image(
                Description=description,
                InstanceId=id,
                Name=name
        )

        try:
            image=ec2.describe_images(ImageIds=[imgid['ImageId']])
            while image['Images'][0]['State'] == 'pending':
                time.sleep(5)
                image=ec2.describe_images(ImageIds=[imgid['ImageId']])

                if image['Images'][0]['State'] != 'pending':
                    break

            if image['Images'][0]['State'] == 'available':
                print("AMI ID: "+imgid['ImageId']+" created OK")
            else:
                print("AMI ID: "+imgid['ImageId']+" created FAILED")
        except Exception as e:
            print("ERROR: "+str(e))
            print("Removing AMI")
            ec2.deregister_image(ImageId=imgid['ImageId'])
