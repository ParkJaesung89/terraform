<!--현재 구성은 terraform module에 대한 이해를 하기위한 테스트 구성입니다.-->
안녕하세요. terraform을 활용한 AWS 인프라 구축 프로젝트입니다.  
아래는 기본적인 웹 이중화 구성입니다.  

![terraform 구성도](https://github.com/ParkJaesung89/terraform/assets/42027536/e38d9f2e-fda8-4a22-a218-4464a6745ff6)


# 구성에 대한 흐름
1) 유저가 www.jsp-tech.com 이라는 도메인으로 접근
2) CF_WAF(Global)에서 "US, KR" 국가에서만 접근이 가능하며, 특정 IP 등록시 해당 IP들도 차단됨.
3) Cloudfront로 접근 후 Header에 "jsp-tech" 값 추가하여 LB로 전달
4) ALB_WAF(Seoul)에서 요청 패킷 Header에 "jsp-tech" 값이 존재하는지 체크하여 있을 경우에만 통과
5) ALB에서 80포트로 접근 시 443포트로 리다이렉트, 443포트로 접근 시 target group인 web-a, web-c 서버로 forwarding
6) web 서버안의 nginx 페이지를 loadbalansing(round robin) 하여 보여줌.  


# 현재 terraform 코드 활용하여 구성 시 사용방법 및 팁
- 상태파일(terraform.tfstate)의 관리를 위하여 backend는 s3로, s3에 tfstate 파일을  
  저장 및 versioning하여 관리되며, dynamoDB의 table의 lock을 활용하여 동시작업을 막았습니다.(혼자 작업시에는 문제되지 않으나, 여러사람과 협업시에 중복작업 하게되면 문제가 발생할 수 있기 때문입니다.)
  > backend를 사용하지 않을 경우 init.tf의 전체 내용과 provider.tf 파일의 backend 설정 주석처리

- terraform workspace를 이용하여 여러 환경에 각각 구성이 가능합니다. 특정 workspace를 생성하여 지정하지 않을 경우에는 "default"가 기본 workspace입니다.
  ```bash
  terraform workspace list                        # workspace 리스트 확인
  terraform workspace new {$workspace_name}       # workspace 생성
  terraform workspace select {$workspace_name}    # workspace 선택
  terraform workspace delete {$workspace_name}    # workspace 삭제
  terraform workspace show                        # 현재 workspace 확인
  ```

- 웹서버에서 사용할 도메인은 aws에서 직접 구매한 것이 아닌 타 업체의 도메인을 가져와서 샤용해야 됩니다.
  그래서 terraform apply 시에 acm 인증부분을 지속적으로 시도하기 때문에 route 53에 hosted zones에서 해당 도메인에 대한 NS 레코드값을 도메인에 설정해준 후에 전파가 되어야 이후의 작업이 진행됩니다.
  > 전파가 느릴 경우 NS 레코드의 TTL 값을 낮춰서 전파 시간을 줄일 수 있습니다.

- rds는 패스워드를 직접 입력하는 방법으로 생성하였으며, 코드상에 패스워드를 노출하지 않도록 secrets manager를
  이용해서 랜덤 패스워드 값으로 secret value에 저장하고 해당 값을 rds password에 적용하였습니다.
  > 다만, terraform.tfstate 파일에 확인해보면 secret value 값이 그대로 노출되있는 것을 확인하여, 이부분 보완하려고
    합니다.



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


github - jenkins - terraform 배포 테스트 진행완료
telegram notification 설정 중!!!
