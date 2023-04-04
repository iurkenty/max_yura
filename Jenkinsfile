pipeline {
    agent any

    environment{

        DOCKERHUB_USERNAME = "iurkenty"
        APP_NAME           = "cicd_proj"
        IMAGE_TAG          = "${BUILD_NUMBER}"
        IMAGE_NAME         = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        REGISTRY_CREDS     = "dockerhub"

    }

    stages{
        stage('Clean Current Workspaces'){
            steps{
               script{
                  cleanWs()
               }
            }
        }
        stage('Checkout GitHub'){
            steps{
               script{
                   git credentialsId: 'github',
                   url: 'https://github.com/iurkenty/max_yura.git',
                   branch: 'development'
               }
            }
       }
        stage('Docker Image Build'){
            steps{
               script{
                  docker_image = docker.build "${IMAGE_NAME}", "./app/Dockerfile"
               }
            }
        }
    }
}