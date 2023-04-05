pipeline {
    agent any

    environment{

        JENKINS_CD_URL     = "http://52.33.147.5:8080/job/argocd/buildWithParameters?token=argocd-config"
        GITHUB_EMAIL       = "vadaturschii.iurii@gmail.com"
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
//CD portion of the pipeline
//        stage('Update k8s deployment file'){
//            steps{
//               script{
//
//                    sh """
//                    cat deployment.yml
//                    sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment.yml
//                    cat deployment.yml
//                    """ 
//               }
//            }
//        }
//        stage('push k8s manifest to GitHub'){
//           steps{
//               script{
//
//                   sh """
//                     git config --global user.name "${DOCKERHUB_USERNAME}"
//                     git config --global user.email "${GITHUB_EMAIL}"
//                     git add deployment.yml
//                     git commit -m "updated the deployment.yml"
//                   """ 
//                    withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')]) {
//
//                    sh "git push https://github.com/iurkenty/max_yura.git development"    
//                   }
//               }
//           }
//       }
         stage('Trigger ArgoCD job'){
            steps{
                script{
                    sh "curl -v -k --user admin:115a17f153948c165ab5475d84d7382675 -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' "${JENKINS_CD_URL}" "
                }
            }
         }
    }
}