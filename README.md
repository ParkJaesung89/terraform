<!-- test3 -->
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
=====================================================================

# 현재 구성에서 terraform 사용
- 현재 terraform 구성에서 backend는 s3로 사용중이며, s3의 tfstate 파일을 관리하기위하여 dynamoDB의 table 사용.
- backend를 사용하지 않을 경우 init.tf 파일 주석처리, provider.tf 파일의 backend 설정 주석처리

## terraform으로 환경 및 리소스 생성 작업 순서
1. terraform 사용하기 위한 디렉토리에 초기화 진행
```bash
terraform init
```
2. workspace 생성 및 적용
```bash
terraform workspace new {workspace name}
terraform workspace select {workspace name}
terraform workspace list
```
3. tfstate 파일을 관리하기 위한 backend 구성을 위해서 우선 s3와 dynamodb 테이블이 구성되어 있어야됨.
   - 'provider.tf' 파일에 backend 설정만 주석처리
4. plan 으로 에러 없이 리소스들이 제대로 생성되는지 체크 후 apply로 생성
```bash
terraform plan
terraform apply
yes
```
5. 모든 리소스 생성 완료 후 terraform backend 적용을 위해서 주석처리했던 backend 설정 주석 제거 후 적용
```bash
terraform init
terraform plan
terraform apply
yes
```

## terraform 구성되어있는 환경을 제거
1. s3 버킷 안에 tfstate 파일등이 존재하기 때문에 기본적으로 삭제 불가능(s3 리소스 설정에 강제 삭제 옵션 추가필요)
```bash
resource "aws_s3_bucket" "terraform_tfstate" {
  bucket        = "jsp-tfstate"
  force_destroy = true      #false         <= 해당 설정으로 강제로 삭제 가능함
}
```
2. 모든 리소스 삭제
```bash
terraform destroy
```
3. 추가로 backend 설정에 s3로 매핑되어있기 때문에 backend 주석처리 및 terraform 디렉토리안에 존재하고있는 tfstate 파일 직접 삭제 조치(terraform 명령을 통해 삭제했어도 기본 terraform 환경에 대한 상태값은 tfstate 값에 남아있음.)
- 해당 조치가 가장 중요한 이유는 실제로는 삭제되어있으나 terraform에서 s3 backend 설정 값에대한 정보가 남아있기 때문에 s3를 찾을 수 없어서 에러발생하여 새로운 작업 등 명령어가 사용불가능함.
- tfstate 파일 경로 : {terraform 디렉토리}/terraform.tfstate.d/{workspace}/terraform.tfstate
=====================================================================

[개인 미션] <!-- 추가해야 될 것들 -->
[lb_target]
1. targets 에 ec2 등록할것
2. 엑세스 로그 같은 cloudwatch 설정해볼것
3. route 53으로 도메인 연동하기.

[route 53 + ACM]
1. 도메인 생성 + ACM  or  도메인 구입하여 레코드 등록

[rds] 
1. rds 생성 및 ec2 연동

[ec2]
1. ec2 생성시에 스크립트로 초기 프로비저닝 하기

[S3] 
1. S3 생성 및 terraform state 파일 저장하기 + dynamodb 에 암호화
2. 정적 페이지 만들어서 cloudfront 연동하기

[cloudfront]
1. cloudfront 생성하여 alb랑 연동
2. cloudfront 와 s3도 연동

[waf]
1. cloudfront waf에서 ip 접근 제어
2. alb waf에서 cloudfront header 값 필터링
