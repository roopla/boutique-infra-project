pipeline {
    agent {
        label 'terraform-slave' // Make sure your Jenkins slave has this label
    }

    environment {
        GOOGLE_CREDENTIALS = credentials('gcp-service-account-key') // Jenkins credential ID for GCP SA key
        TF_VAR_project = 'playground-s-11-05c70481'   // Replace with actual GCP project
        TF_VAR_region  = 'us-central1'
        TF_VAR_zone    = 'us-central1-a'
    }

    options {
        skipStagesAfterUnstable()
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repo...'
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
            steps {
                sh '''
                terraform plan -input=false -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve Apply?'
                sh '''
                terraform apply -input=false tfplan
                '''
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed — check console output.'
        }
        success {
            echo '✅ Terraform apply completed successfully.'
        }
    }
}
