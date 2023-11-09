<!--현재 구성은 terraform module에 대한 이해를 하기위한 테스트 구성입니다.-->

<h1> terraform 모듈 사용하는 방법에 대해서 정리 </h1>

모듈은 크게 root , child 모듈로 나눌 수 있다.  
1. root모듈은 child 모듈들에 대해서 정의 및 실제 리소스를 관리한다.
2. child 모듈은 리소스 구성에 대한 정의를 내린다.  
  

## Child Modules
child 모듈안에는 크게 3가지 파일이 존재한다.  
- main.tf
- variables.tf
- output.tf  

1. main.tf는 실제 리소스를 정의 한다.

2. variables.tf는 main.tf에서 정의 한 리소스안의 변수들에 대해서 정의 한다.

3. output.tf는 root 모듈에서 각 module들을 정의 할때 다른 모듈에서 참조해야 될 값들을 사용하기 위하여 정의 해둔다.
	1) 각 모듈에서 output.tf에 필요한 모듈을 정의
                  output "vpc_id" {
             value = aws_vpc.vpc.id
           }
	2) root 모듈의 output.tf에 특정 모듈의 output을 모듈정의한다.
                  output "vpc_id" {
             value = module.vpc.vpc_id				#module.vpc(vpc모듈)에서 vpc_id라는 output의 정의를 참조한다는 뜻
           }

## Root Module
root 모듈에는 크게 4가지 중요 파일이 존재한다.
- root.tf(main.tf)
- variables.tf
- output.tf
- terraform.tfvars  

1. root 모듈은 child 모듈들에 대한 정의를 내린다.  

2. variables.tf는 각 모듈에서 사용하는 변수들을 정의한다.  
(child 모듈과 동일하게 변수를 정의하기 때문에 중복되는 경우가 대부분)  

3. output.tf 위에 아웃풋 설명과같이 각 특정 모듈들에 대한 참조할 output 들을 모듈 정의한다.  

4. terraform.tfvars는 실제로 root variables.tf에서 정의한 변수들에 대한 값들을 작성한다.  
    ```
    실제로 root에 있는 variables.tf와 child들에 있는 variables.tf에 동일한 변수가 있어야 terraform.tfvars에서 설정한 변수 값을 동일하게 인지한다.
    쉽게 말해서 root와 child의 변수를 똑같이 정의 내려둬야됨.
    ```