#!groovy

pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    disableConcurrentBuilds()
  }
  agent any
   parameters{
    string(name: 'TAG', defaultValue: 'develop-latest', description: 'Please change the image tag.')
    choice(name: 'ECR_REPO', choices: ['blue', 'green'], description: 'Please choose ECR repo you wish to build image for?')
    string(name: 'AWS_REGION', defaultValue: 'us-west-2', description: 'Please provide AWS region for ECR repo.')
    string(name: 'MESSAGE', defaultValue: 'Welcome to DevOpsForAll ECS Demo for Blue Targets.1.0!', description: 'Please provide Message for deployment notes.')
    choice(name: 'ECS_CLUSTER', choices: ['Blue-cluster', 'Green-cluster'], description: 'Please choose the ECS cluster you wish to do deployment for?')
    choice(name: 'ECS_SERVICE', choices: ['blue-app', 'green-app'], description: 'Please choose the ECS service name you wish to do deployment for?')
    choice(choices: ['YES', 'NO'], description: 'Wish to Deploy This image?', name: 'DEPLOY')
}
  stages {
   stage('Docker Image Build') {
      steps {
        script {
          sh './image-build.sh'
        }
      }
    }
   stage('Image Push Private Repo') {
      steps {
        script {
          sh './image-push.sh'
        }
      }
    }
   stage('Deploy to ECS') {
      when {
      expression { params.DEPLOY == 'YES' }
    }
      steps {
        script {
          sh './deploy.sh'
        }
      }
    }
}
}
