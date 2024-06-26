#############################################################
# RDS - KMS Key
#############################################################

resource "aws_kms_key" "kms_db_key" {
  description = "jsp-db-key"
}



#############################################################
# RDS - Secret Manager
#############################################################

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Creating a AWS secret for database master account (Masteraccoundb)
resource "aws_secretsmanager_secret" "jsp_db_secret" {
  name = format("%s-db-pw", lower(var.name))
  kms_key_id = aws_kms_key.kms_db_key.id
  depends_on = [aws_kms_key.kms_db_key]
}

# Creating a AWS secret versions for database master account (Masteraccoundb)
resource "aws_secretsmanager_secret_version" "jsp_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.jsp_db_secret.id
  secret_string = jsonencode(                                   # encode in the required format
    {
      password = random_password.password.result
    }
  )
}

data "aws_secretsmanager_secret" "jsp_db_secret" {
  arn = aws_secretsmanager_secret.jsp_db_secret.arn
  depends_on = [aws_secretsmanager_secret.jsp_db_secret]
}

# Importing the AWS secret version created previously using arn.
data "aws_secretsmanager_secret_version" "jsp_db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.jsp_db_secret.id
}

# After importing the secrets storing into Locals
locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.jsp_db_secret_version.secret_string
  )
}

###################################################################################
###################################################################################




resource "aws_rds_cluster_parameter_group" "jsp_parameter_group" {
  name = format("%s-%s-pg", lower(var.name), terraform.workspace)
  family = "aurora-mysql8.0"

  #parameter {
  #  name = "character_set_server"
  #  value = "utf8mb4"
  #}
  #
  #parameter {
  #  name = "character_set_client"
  #  value = "utf8mb4"
  #}
  # 
  #parameter {
  #  name = "server_audit_logging"
  #  value = "1"
  #}

  parameter {
    name = "server_audit_events"
    value = "CONNECT"     # Allowed values [CONNECT,QUERY,QUERY_DCL,QUERY_DDL,QUERY_DML,TABLE]
  }
}




# Create RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name = format("%s-db-subnet-group", lower(var.name))
  subnet_ids = var.db_sub_ids
}


# Create RDS Cluster
resource "aws_rds_cluster" "aurora_mysql_db" {
  cluster_identifier = format("%s-db", lower(var.name))
  engine_mode = var.engine_mode
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  #db_cluster_instance_class = var.instance_class
  engine = var.engine
  engine_version = var.engine_version
  availability_zones = var.availability_zones
  #storage_type = var.storage_type
  #allocated_storage = var.allocated_storage
  #iops = var.iops      #aurora-mysql에서는 해당 옵션이 없음
  database_name = var.database_name
  master_username = var.master_username
  master_password = local.db_creds.password
  #manage_master_user_password = true    # secrets_manager 자동생성 및 관리 - 해당 설정 시 master_password 설정은 불가능
  skip_final_snapshot = var.skip_final_snapshot       # RDS 삭제 시, 스냅샷 생성 여부 설정(true - 스냅샷 생성 X)
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.jsp_parameter_group.name
  storage_encrypted = true

  lifecycle {
    ignore_changes = [master_password, availability_zones]
  }

  depends_on = [aws_rds_cluster_parameter_group.jsp_parameter_group, aws_db_subnet_group.db_subnet_group]
}


resource "aws_rds_cluster_instance" "aurora_mysql_db-instance" {
  count = 2
  identifier = format("%s-db-${count.index}", lower(var.name))
  cluster_identifier = aws_rds_cluster.aurora_mysql_db.id
  instance_class = var.instance_class
  engine = var.engine
  engine_version = var.engine_version
  publicly_accessible = false        # public 으로 사용시 true
  apply_immediately                     = false
}
