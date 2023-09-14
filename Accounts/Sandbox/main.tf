resource "aws_instance" "test_ec2" {
    ami = lookup(var.env, "ami")
    instance_type = lookup(var.env, "instance_type")
    subnet_id = lookup(var.env, "subnet_id")
    vpc_security_group_ids = [aws_security_group.test_ec2_sg.id]
    key_name = lookup(var.env, "kp_name")
    metadata_options {
        http_tokens = "required"
        http_endpoint = "enabled"
    } 
    lifecycle {
        ignore_changes = [user_data, ami]
    }

}

resource "aws_key_pair" "test_ec2_key_pair" {
    key_name  = lookup(var.env,"kp_name")
    public_key = tls_private_key.test_ec2_private_key.public_key_openssh

}

resource "tls_private_key" "test_ec2_private_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "local_test_ec2_private_key" {
    content = tls_private_key.test_ec2_private_key.private_key_pem
    filename = "sec_ec2_test_kp"
}

resource "aws_security_group" "test_ec2_sg" {
    name = lookup(var.env, "SG")
    description = "SG for security test EC2 instance"
    vpc_id = lookup(var.env, "vpc")
    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = ["136.36.4.59/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    lifecycle {
        create_before_destroy = true
    }

}

variable "env" {
    type = map(string)
    default = {
        vpc = "vpc-<>"
        ami = "ami-<>"
        instance_type = "t2.micro"
        subnet_id = "subnet-<>"
        kp_name = "security_test_ec2_kp"
        SG = "sec-test-ec2-security-group"
    }
}

