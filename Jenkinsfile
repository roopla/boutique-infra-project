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
            choices: "init\validate\nplan\napply\ndestroy",
            description: 'Choose terraform workflow'
        )
    }
   
    stages {
        
        stage('init') {
            steps {
                sh """
                    terraform init 
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