resource "aws_vpc" "jsp_vpc" {

    cidr_block = "10.0.0.0/16"
    
    tags = {
	"Name" = "jsp-vpc"
    }
}
