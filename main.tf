provider "kubernetes" {
  config_context = "minikube"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "shubham"
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wp"
    labels = {
      env = "testing"
    }
  }
  spec {
    selector {
      match_labels = {
        env = "testing"
      }
    }
    template {
      metadata {
        labels = {
          env = "testing"
        }
      }
      spec {
        container {
          image = "wordpress:latest"
          name  = "wp"

          }
        }
      }
    }
  }

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wp"
  }
  spec {
    selector = {
      env = "testing"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  name                 = "wordpress"
  username             = "root"
  password             = "12345678"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible = "true"
  port = "3306"
}

output "Database_Name" {
  value = aws_db_instance.mydb.name
}

output "Port" {
  value = aws_db_instance.mydb.port
}

output "Database_Username" {
  value = aws_db_instance.mydb.username
}

output "Database_URL" {
  value = aws_db_instance.mydb.endpoint
}




