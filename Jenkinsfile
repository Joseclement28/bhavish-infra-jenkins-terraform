pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'DESTROY',
            defaultValue: false,
            description: 'Destroy infrastructure'
        )
    }

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
        TF_PLUGIN_CACHE_DIR = "${WORKSPACE}/.terraform.d/plugin-cache"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Joseclement28/bhavish-infra-jenkins-terraform.git'
            }
        }

        stage('Prepare Terraform Cache') {
            steps {
                sh 'mkdir -p $TF_PLUGIN_CACHE_DIR'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'terraform init -reconfigure'
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY }
            }
            input {
                message "Approve Terraform Apply?"
                ok "Apply"
            }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY }
            }
            input {
                message "⚠️ Confirm Terraform Destroy?"
                ok "Destroy Infrastructure"
            }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully ✅"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
