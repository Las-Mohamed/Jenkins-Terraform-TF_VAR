pipeline {
    agent any
   /* environment {
        MY_CRED = credentials('f2d10700-72b4-4064-b1d8-1a4882c4f29f')
}*/
    stages {
     stage('Clone') {
         steps{
            checkout scm
         }
    }
   /* stage('Credentials') {
        steps{
            sh 'az login --service-principal -u $MY_CRED_CLIENT_ID -p $MY_CRED_CLIENT_SECRET -t $MY_CRED_TENANT_ID'
        }
    }*/
  
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
