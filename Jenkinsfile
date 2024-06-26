pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        REGION = credentials('AWS_REGION')
        
        // Telegram configre
        //TOKEN = credentials('telegram-api')
        //CHAT_ID = credentials('telegram-chatid')

        // Telegram Message Pre Build
        CURRENT_BUILD_NUMBER = "${currentBuild.number}"
        GIT_MESSAGE = sh(returnStdout: true, script: "git log -n 1 --format=%s ${GIT_COMMIT}").trim()
        GIT_AUTHOR = sh(returnStdout: true, script: "git log -n 1 --format=%ae ${GIT_COMMIT}").trim()
        GIT_COMMIT_SHORT = sh(returnStdout: true, script: "git rev-parse --short ${GIT_COMMIT}").trim()
        GIT_INFO = "Branch(Version): ${GIT_BRANCH}\nLast Message: ${GIT_MESSAGE}\nAuthor: ${GIT_AUTHOR}\nCommit: ${GIT_COMMIT_SHORT}"
        TEXT_BREAK = "--------------------------------------------------------------"
        TEXT_PRE_BUILD = "${TEXT_BREAK}\n${GIT_INFO}\n${JOB_NAME} is Building"

        // Telegram Message Success and Failure
        TEXT_SUCCESS_BUILD = "${JOB_NAME} is Success"
        TEXT_WAITING_BUILD = "Waiting for ${JOB_NAME}"
        TEXT_FAILURE_BUILD = "${JOB_NAME} is Failure"
    }

    stages {
        
        stage('Pre-Build') {
            steps {
		  script{
                        withCredentials([string(credentialsId: 'telegram-api', variable: 'TOKEN'), string(credentialsId: 'telegram-chatid', variable: 'CHAT_ID')]) {
                                        sh "curl --location --request POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' --form 'text=${TEXT_PRE_BUILD}' --form 'chat_id=${CHAT_ID}'"
                                        //sh ' curl -s -X POST https://api.telegram.org/bot"$TOKEN"/sendMessage -d chat_id="$CHAT_ID" -d text="$TEXT_PRE_BUILD" '
                        }
                  }
            }
        }
        stage('Plan') {

            steps {
                sh 'terraform init -upgrade'
                sh "terraform validate"
                sh "terraform plan"
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }
           
           steps {
               script {
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan')]

               }
           }
       }

        stage('Apply') {
            steps {
                sh "terraform apply --auto-approve"
            }
            post {
                 always {
                        script{
                              withCredentials([string(credentialsId: 'telegram-api', variable: 'TOKEN'), string(credentialsId: 'telegram-chatid', variable: 'CHAT_ID')]) {
                                       sh "curl --location --request POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' --form 'text=${TEXT_PRE_BUILD}' --form 'chat_id=${CHAT_ID}'"
                                       //sh ' curl -s -X POST https://api.telegram.org/bot"$TOKEN"/sendMessage -d chat_id="$CHAT_ID" -d text="$TEXT_PRE_BUILD" '
                              }
                        }
                 }
            }
        }
    }
}
