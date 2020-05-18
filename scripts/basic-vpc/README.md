# AWS CLI VPC Creation script

Creates a basic VPC using CLI

# The steps

* Create a VPC
  - ```aws ec2 create-vpc --cidr-block 10.1.0.0/16```
* Create Public Subnet
  - ```aws ec2 create-subnet --vpc-id $vpcid --cidr-block=10.1.1.0/24```
* Create Private Subnet
  - ```aws ec2 create-subnet --vpc-id $vpcid --cidr-block=10.1.2.0/24```
* Add Internet Gateway (to allow in and out Internet traffic)
  - ```aws ec2 create-internet-gateway```
* Attach Internet Gateway to VPC
  - ```aws ec2 attach-internet-gateway --vpc-id $vpcid --internet-gateway-id $igwID```
* Create Public Route Table
  - ```aws ec2 create-route-table --vpc-id $vpcid```
* Associate Internet Gateway to Public Route Table
  - ```aws ec2 create-route --route-table-id $rtbID --destination-cidr-block 0.0.0.0/0 --gateway-id $igwID```
* Associate Public subnet to Public Route Table
  - ```aws ec2 associate-route-table  --subnet-id $pubSubId --route-table-id $rtbID```
* Get a Public IP address
  - ```aws ec2 allocate-address --domain vpc```
* Create NAT Gateway
  - ```aws ec2 create-nat-gateway --allocation-id $allocID --subnet-id $pubSubId```
  - Wait for this to become available
* Create private route table
  - ```aws ec2 create-route-table --vpc-id $vpcid```
* Associate private subnet to private route table
  - ```aws ec2 associate-route-table  --subnet-id $privSubId --route-table-id $privrtbID```
* Associate private subnet to NAT Gateway
  - ```aws ec2 create-route --route-table-id $privrtbID --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $natGWID```
* Map public IP on launch to public Subnet
  - ```aws ec2 modify-subnet-attribute --subnet-id $pubSubId --map-public-ip-on-launch```
* Create security group and assign ingress rules
  - ```aws ec2 create-security-group --description "Steves SG" --group-name SteveSG --vpc-id $vpcid```
  - ```aws ec2 authorize-security-group-ingress --group-id $sgID --protocol tcp --port 22 --cidr 0.0.0.0/0```
  - ```aws ec2 authorize-security-group-ingress --group-id $sgID --protocol tcp --port 80 --cidr 0.0.0.0/0```
  - ```aws ec2 authorize-security-group-ingress --group-id $sgID --protocol all --port 1-65535 --cidr 10.1.0.0/16```
* Create an instance in each subnet
  - ```aws ec2 run-instances --security-group-ids  \
        --key-name steveshilling --subnet-id $pubSubId \
        --instance-type t2.micro --image-id $amiID \
        --associate-public-ip-address```
  - ```aws ec2 run-instances --security-group-ids  \
        --key-name steveshilling --subnet-id $privSubId \
        --instance-type t2.micro --image-id $amiID```
