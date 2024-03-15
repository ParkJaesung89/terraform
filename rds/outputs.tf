# mysql 설정 및 db와의 연동을 위해 endpoint 추출
output "rds_writer_endpoint" {
  value = aws_rds_cluster.aurora_mysql_db.endpoint
}