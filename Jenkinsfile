pipeline {
    agent any

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure if checked')
    }

    environment {
        GOOGLE_CREDENTIALS = credentials('gcp-service-account-key')
    }

    stages {
        stage('Checkout Repo') {
            steps {
                echo 'Checking out code...'
                git url: 'https://github.com/roopla/boutique-infra-project.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    writeFile file: 'jenkins.tfvars', text: "${TFVARS_FILE}"
                    sh 'terraform plan -input=false -var-file=${TFVARS_FILE}'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                input message: 'Approve Apply?', ok: 'Apply', submitter: 'sivesre'
                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    sh 'terraform apply -input=false -auto-approve -var-file=${TFVARS_FILE}'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY }
            }
            steps {
                input message: 'Approve Destroy?', ok: 'Destroy', submitter: 'sivesre'
                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    sh 'terraform destroy -input=false -auto-approve -var-file=${TFVARS_FILE}'
                }
            }
        }
    }

   


    post {
        always {
            echo 'Cleaning up...'
            sh 'rm -f jenkins.tfvars || true'
        }
        failure {
            echo 'Pipeline failed.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
    }
}
