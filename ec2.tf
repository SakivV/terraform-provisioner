resource "aws_instance" "class-ec2-server" {
  instance_type = var.ec2_instance_type #Refer value from ec2_instance_type variable
  ami = data.aws_ami.ec2_ami_image.id
  vpc_security_group_ids = [aws_security_group.class-ec2-server-sg.id]
  key_name = "terraform-key" #Modify key as per key created in your account.
  user_data = file("nginx.sh")
  tags = {
    "Name" = "${var.aws_lb_project}"
  }

  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type = "ssh"
    host = self.public_ip # Understand what is "self"
    user = "ubuntu"
    password = ""
    private_key = file("key/terraform-key.pem")
  }  

  
  provisioner "local-exec" {
    working_dir = "key/"
    command = "echo ${aws_instance.class-ec2-server.public_dns} >> ec2_info.txt"
  }

  #File Provisioner to copy files to tmp folders.
  provisioner "file" {
    source      = "app/"
    destination = "/tmp"
  }

  #Remote Provisioner to copy files from tmp folder to Nginx server folder.
  provisioner "remote-exec" {
    inline = [
      "sleep 75", 
      "sudo cp /tmp/index.html /var/www/html/index.html",
      "sudo cp /tmp/components.html /var/www/html/components.html",
      "sudo cp -r /tmp/assets /var/www/html/assets"
    ]
  }

}

resource "aws_security_group" "class-ec2-server-sg" {
  name        = "${var.aws_lb_project}-ec2-security-group"
  description = "EC2 Security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.160.119.249/32"] #Change IP Address as per your need
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["87.210.240.126/32"] #Change IP Address as per your need
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.class-nginx-lb-sg.id] #Change IP Address as per your need
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = -1
  }
  
}