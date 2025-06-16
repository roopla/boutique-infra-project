pipeline  {
    agent {
        label 'terraform-slave'
    }

    parameters {
<<<<<<< HEAD
        choice(
            name: 'ENVIRONMENT',
            choices: ['na', 'dev', 'test', 'stage','prod']
            description: 'Select the environment for Terraform deployment'
        )

        choice(
            name: 'ACTION',
            choices: 'validate\nplan\napply\ndestroy'
            description: 'Select Terraform action to perform'
        )
    }

    stages {
        stage('init') {
            steps {
                
=======
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
>>>>>>> bf16bc531315544df43c36a74aedc5ad80a722b1
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                        terraform init -input=false
                    '''
                 
            }
        }

<<<<<<< HEAD
        stage('Validate') {
            steps {
                
                    sh '''
                        
                        terraform validate
                    '''
                 
            }
        }
        
        stage('Plan') {
            steps {
                
                    sh '''
                        
                        terraform plan -var-file=terraform.tfvars -out=tfplan
                    '''
                
            }
        }

        stage('Apply') {
            steps {
                script {
                   
                        sh '''
                            
                            terraform apply -auto-approve tfplan
                        '''
                    
=======
        stage('Terraform Plan') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    writeFile file: 'jenkins.tfvars', text: "${TFVARS_FILE}"
                    sh 'terraform plan -input=false -var-file=${TFVARS_FILE}'
>>>>>>> bf16bc531315544df43c36a74aedc5ad80a722b1
                }
            }
        }

<<<<<<< HEAD
        stage('Destroy') {
            steps {
                
                    sh '''
                        
                        terraform destroy -var-file=terraform.tfvars -auto-approve
                    '''
               
            }
        }
    }
}
=======
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
>>>>>>> bf16bc531315544df43c36a74aedc5ad80a722b1
