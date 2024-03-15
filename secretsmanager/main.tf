resource "random_password" "password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "jsp_sm" {
  name = format("%s-secret-manager", lower(var.name))
}


resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.jsp_sm.id
  secret_string = jsonencode(                                   # encode in the required format
    {
      password = random_password.password.result
    }
  )
}


data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.jsp_sm.id
}
