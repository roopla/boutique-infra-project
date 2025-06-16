pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select Terraform action to perform'
        )
    }

    environment {
        // GCP service account key stored in Jenkins Credentials as secret file
        GOOGLE_CREDENTIALS = credentials('gcp-service-account-key')
    }

    options {
        skipStagesAfterUnstable()
    }

    stages {
        stage('Init-State') {
            steps {
                script {
                    echo "Initializing Terraform..."
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CREDENTIALS
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Plan-Stage') {
            when {
                expression { params.ACTION == 'plan' }
            }
            steps {
                script {
                    echo "Running terraform plan..."
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CREDENTIALS
                        terraform plan -var-file=terraform.tfvars -out=tfplan
                    '''
                }
            }
        }

        stage('Apply-Stage') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    def user = currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause)?.getUserId()
                    if (user != 'sivesre') {
                        error("Access denied: Only user 'sivesre' is authorized to apply Terraform changes.")
                    }
                }
                script {
                    echo "Applying Terraform changes..."
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CREDENTIALS
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Destroy-Stage') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                script {
                    def user = currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause)?.getUserId()
                    if (user != 'sivesre') {
                        error("Access denied: Only user 'sivesre' is authorized to destroy infrastructure.")
                    }
                }
                script {
                    echo "Destroying Terraform-managed infrastructure..."
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CREDENTIALS
                        terraform destroy -auto-approve -var-file=terraform.tfvars
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Terraform pipeline execution completed with action: ${params.ACTION}"
        }
        failure {
            echo "Pipeline failed during action: ${params.ACTION}"
        }
        success {
            echo "Pipeline succeeded for action: ${params.ACTION}"
        }
    }
}
