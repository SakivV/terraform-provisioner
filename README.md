# terraform-provisioner
# Terraform Provisioners
In this demo we are going to user ```file``` provisioner and ```remote``` provisioner.
1. First we are going to copy files from `app` folder to `tmp` folder on EC2 instance.
2. After that we are going to copy files `tmp` folder to nginx server folder.

# Prerequisite
1. Create Keypair under EC2 console. (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)
2. Change key permission 400.
# Steps to follow:
1. Clone Repo.
2. Make sure you refer branch `remote-prov`
3. In `version.tf` file make sure you have backend configured correctly as per the bucket and dynamodb table. 
4. Also in EC2 block and in connection block, you need to use Key  that you have created in Prerequisite.