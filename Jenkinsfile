pipeline  {
    agent {
        label 'terraform-slave'
    }

    parameters {
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
                
                    sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CREDENTIALS
                        terraform init -input=false
                    '''
                 
            }
        }

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
                    
                }
            }
        }

        stage('Destroy') {
            steps {
                
                    sh '''
                        
                        terraform destroy -var-file=terraform.tfvars -auto-approve
                    '''
               
            }
        }
    }
}