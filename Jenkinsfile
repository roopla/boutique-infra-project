pipeline {
    agent any

    environment {
        GOOGLE_CREDENTIALS = credentials('gcp-service-account-key') // Jenkins ID of your GCP SA key
        TF_VAR_project = 'playground-s-11-05c70481'   // replace with actual project ID
        TF_VAR_region  = 'us-central1'
        TF_VAR_zone    = 'us-central1-a'
    }

    parameters {
        choice(name: 'ACTION', choices: ['init', 'plan', 'apply'], description: 'Terraform action to perform')
    }

    options {
        skipStagesAfterUnstable()
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning boutique-infra-project repo...'
                git url: 'https://github.com/roopla/boutique-infra-project.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            when {
                expression { params.ACTION == 'init' || params.ACTION == 'plan' || params.ACTION == 'apply' }
            }
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
                expression { params.ACTION == 'plan' || params.ACTION == 'apply' }
            }
            steps {
                sh '''
                terraform plan -input=false -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
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
            echo 'Pipeline failed — investigate logs.'
        }
        success {
            echo 'Terraform pipeline completed successfully.'
        }
    }
}
