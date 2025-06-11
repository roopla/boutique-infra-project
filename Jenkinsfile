pipeline {
    agent any

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Check this to destroy all infra')
    }

    environment {
        GOOGLE_CREDENTIALS = credentials('gcp-service-account-key')

        TF_VAR_project_id     = 'playground-s-11-05c70481'
        TF_VAR_region         = 'us-central1'
        TF_VAR_zone           = 'us-central1-a'
        TF_VAR_vpc_name       = 'vpc-playground'
        TF_VAR_subnet_name    = 'subnet-playground'
        TF_VAR_subnet_cidr    = '10.9.0.0/16'
        TF_VAR_vm_name        = 'vm-playground'
        TF_VAR_machine_type   = 'e2-medium'
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
            when {
                expression { return !params.DESTROY }
            }
            steps {
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                input message: 'Approve Apply?'
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY }
            }
            steps {
                input message: 'Approve Destroy? This will delete all provisioned infrastructure.'
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        failure {
            echo '❌ Terraform pipeline failed — check logs.'
        }
        success {
            echo '✅ Terraform pipeline completed.'
        }
    }
}
