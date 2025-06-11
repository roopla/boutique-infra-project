pipeline {
    agent any

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Check to destroy infrastructure instead of applying')
    }

    environment {
        GOOGLE_CREDENTIALS = credentials('gcp-service-account-key')
    }

    stages {
        stage('Fetching from git repo') {
            steps {
                echo 'Cloning repo...'
                git url: 'https://github.com/roopla/boutique-infra-project.git', branch: 'main'
            }
        }

        stage('Init') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                    export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                    terraform init -input=false
                    '''
                }
            }
        }

        stage('Plan') {
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

        stage('Apply') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                script {
                    def userInput = input(
                        id: 'ApplyApproval',
                        message: 'Approve Apply?',
                        ok: 'Proceed'
                    )
                    def approvedBy = currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause)?.userId
                    if (approvedBy != 'sivesre') {
                        error "Only 'sivesre' is authorized to approve Apply. Approved by: ${approvedBy}"
                    }
                }

                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    sh 'terraform apply -input=false -auto-approve -var-file=${TFVARS_FILE}'
                }
            }
        }

        stage('Destroy') {
            when {
                expression { return params.DESTROY }
            }
            steps {
                script {
                    def userInput = input(
                        id: 'DestroyApproval',
                        message: 'Approve Destroy? This will delete all provisioned infrastructure.',
                        ok: 'Destroy'
                    )
                    def approvedBy = currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause)?.userId
                    if (approvedBy != 'sivesre') {
                        error "Only 'sivesre' is authorized to approve Destroy. Approved by: ${approvedBy}"
                    }
                }

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
