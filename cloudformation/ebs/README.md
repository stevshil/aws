# Jenkins EBS

This module will create a simple VPC with Public subnet.  This is created with the create-vpc script.

A Jenkins instance can then be created in that VPC.  You'll need to view the outputs of the VPC creation to get the values for VPC and add them to the create-instance script and the recreate-instance script.
Note, you will also need to change the instance ID if running it outside of eu-central-1, you will also need to change the DNS Zone ID.

The EBS is create with the create-ebs script to which you will need to get the paramters from the outputs of the earlier scripts.

After running the 3 create scripts in the above order you should then point your web browser at the Jenkins instance, and configure Jenkins.

After configuring Jenkins you should then destroy only the Instance stack, leaving the VPC and EBS in place.  This will ensure that you still have your Jenkins server.

```
aws cloudformation delete-stack --stack-name steveJenkins-Instance
```

Then obtain the volume ID from the outputs on the steveJenkins-Volume stack and add it to the recreate-instance script so that your new instance will attach to the existing EBS and Jenkins will start with its last configuration.
