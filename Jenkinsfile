pipeline {
    agent {
        label 'terraform-slave'
    }
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'test', 'stage', 'prod'],
            description: 'Select Environment'
        )
        choice(
            name: 'ACTION',
            choices: "init\nvalidate\nplan\napply\ndestroy",
            description: 'Choose terraform workflow'
        )
    }

    environment {
        GCS_BUCKET = 'playground-s-11-4152b84f-tf'
        GOOGLE_APPLICATION_CREDENTIALS = "${WORKSPACE}/gcp-key.json"
    }
   
    stages {

        stage ('setup GCE auth') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account_key', variable: 'SA_KEY')]) {
                    sh """
                        cp ${SA_KEY} ${GOOGLE_APPLICATION_CREDENTIALS}  
                        chmod 600 ${GOOGLE_APPLICATION_CREDENTIALS}
                        
                    """
                }
            }
        }
        
        stage('init') {
            steps {
                sh """
                    terraform init -backend-config="bucket=${env.GCS_BUCKET}"  -backend-config="prefix=${params.ENVIRONMENT}"  
                """
            }
        }
        stage('validate') {
            
            when {
                expression { params.ACTION == 'validate' }
            }
            steps {
                sh """
                    terraform validate  
                """
            }
        }
        stage ('Plan') {
           when {
                expression { params.ACTION == 'plan' }
            }
            steps {
                sh """
                    terraform plan 
                """
            }
        }
        stage ('apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh """
                    terraform apply --auto-approve 
                """
            }
        }
        stage ('destroy') {
           when {
                expression { params.ACTION == 'destroy' }
            }
            
            steps {
                sh """
                    terraform destroy --auto-approve 
                """
            }
        }
    }
}