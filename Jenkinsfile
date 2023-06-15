pipeline {
    agent any
    stages {
     stage('Clone') {
         steps{
            checkout scm
         }
     }
    stage('terraform init') {
        steps{
            sh 'terraform init -upgrade'
        }
    }
    stage('terraform apply') {
        steps{
            sh 'terraform apply -var="subscription_id=$AZURE_SUBSCRIPTION_ID" -var="client_id=$AZURE_CLIENT_ID" -var="client_secret=$AZURE_CLIENT_SECRET" -var="tenant_id=$AZURE_TENANT_ID" -auto-approve'
        }
      }
   }
}
