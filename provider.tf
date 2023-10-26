provider "aws" {
    shared_config_files      = ["~/.aws/config"]
	shared_credentials_files = ["~/.aws/credentials"]
	profile					 = "jaesung.park"
	region = var.region
}
