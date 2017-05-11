# 2 Subnet VPC

This configuration splits the configuration of a cloudformation stack into 3 templates;

* vpc.json
* s3bucketsec.json
* vpc-servers.json
* create-only-vpc
** Shell script that contains the aws cli command to build just the VPC
* create-instances
** Shell script that given the outputs of the create-only-vpc will allow you to add instances to the subnets as a separate task.  However, this will only work if you remove the IAM dependency from the vpc-servers.json.
* run-complete
** Shell script that contains the aws cli command to build the entire VPC, Bucket and Instances


It is intended to show how to split your stack into separate templates for project work, how to export resources for use by other templates, and demonstrates the use of secure S3 bucket which can only be access by hosts in the private subnet.

## vpc.json
This is the core template that builds the entire infrastructure.  We could split this so that it does not include the other 2, and then create further exports to obtain the values required for the other templates.

This template mainly builds;
* VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* NAT Gateway
* Routing tables

## s3bucketsec.json
This template is responsible for building a secure S3 bucket which will only be accessible by the private subnet.

It then exports the IAM Instance Profile so that it can be used by the vpc-server.json template on those instances in the private subnet.

## vpc-server.json
This create the security group firewall rules for the servers, and ensures that only public subnet servers can access the private subnet (simplistic view for demo).

It also creates 3 VMs;
* Bastion or Jump host
* Proxy server
** NGINX as a proxy
* Web server (private subnet)
** Apache

This also provisions the Proxy and Web server so that the relevant software is installed.  It also creates a simple index.html on the web server.
