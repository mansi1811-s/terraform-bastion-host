data "template_file" "user_data" {
  template = file("${path.module}/install.sh.tpl")
}


#Dynamically ssh-key pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename          = "KeyV.pem"
  content           = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "KeyV"
  public_key = tls_private_key.key.public_key_openssh
}

# 10 creating public ec2 vm
resource "aws_instance" "public-ec2" {
  ami                         = var.ami_value
  instance_type               = var.instance_type_value
  key_name                    = aws_key_pair.key_pair.key_name
  security_groups             = ["${var.security_group_id}"]
  subnet_id                   = "${var.public_subnet_id}"
  associate_public_ip_address = true
  metadata_options {
     http_tokens = "required"
     }  

  user_data = data.template_file.user_data.rendered

  # To solve HIGH Root block device is not encrypted add following block
   root_block_device {
       encrypted = true
   }

  tags = {
    Name = "${var.public_ec2_name}"
  }


  # 11 Copies the ssh key file to home dir of ec2
  provisioner "file" {
    source      = "./${aws_key_pair.key_pair.key_name}.pem"
    destination = "/home/ubuntu/${aws_key_pair.key_pair.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      host        = self.public_ip
    }
  }

  # 12 chmod key 400 on EC2 instance
  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${aws_key_pair.key_pair.key_name}.pem"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      host        = self.public_ip
    }

  }

}

# 13 creating private ec2 vm
resource "aws_instance" "private-ec2" {
  ami                         = var.ami_value
  instance_type               = var.instance_type_value
  key_name                    = aws_key_pair.key_pair.key_name
  security_groups             = ["${var.security_group_id}"]
  subnet_id                   = "${var.private_subnet_id}"
  associate_public_ip_address = false
  user_data                   = data.template_file.user_data.rendered
  metadata_options {
     http_tokens = "required"
     }  
  # to solve HIGH Root block device is not encrypted. 
  root_block_device {
       encrypted = true
  }
  
  tags = {
    Name = "${var.private_ec2_name}"
  }
}
