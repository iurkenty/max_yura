pipeline {
    agent any

    environment{

        DOCKERHUB_USERNAME = "iurkenty"
        APP_NAME           = "cicd_proj"
        IMAGE_TAG          = "${BUILD_NUMBER}" // BUILD_NUMBER and other vars could be found at http://<Jenkins>:<port>/env-vars.html
        IMAGE_NAME         = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        REGISTRY_CREDS     = "dockerhub"  //dockerhub must be added to Manage Jenkins -> Manage Credentials -> System

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
                  docker_image = docker.build "${IMAGE_NAME}", "app/" //Jenkinsfile syntax ref https://www.jenkins.io/doc/book/pipeline/docker/
               }
            }
        }
        stage('Push Docker Image'){
            steps{
               script{
                  docker.withRegistry('', REGISTRY_CREDS){ //Jenkinsfile syntax ref https://www.jenkins.io/doc/book/pipeline/docker/
                      docker_image.push("${BUILD_NUMBER}")
                      docker_image.push('latest')
                  }
               }
            }
        }
        stage('Remove Docker Image'){
            steps{
               script{

                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
               }
            }
        }
        stage('Update k8s deployment file'){
            steps{
               script{

                    sh """
                    cat deployment.yml
                    sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment.yml
                    cat deployment.yml
                    """ 
               }
            }
        }
    }
}