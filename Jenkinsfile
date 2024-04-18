pipeline{
    agent {label 'Jenkins-Agent'}
    tools {
        jdk 'JDK17'
        maven 'MAVEN3'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages{
        stage ('clean Workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Get Previous Successfully Build Number') {
          steps {
            script {

               def previousBuildNumber = currentBuild.previousSuccessfulBuild?.number
               if (previousBuildNumber == null) {
                   env.IMAGE_TAG_VERSION = 'latest'
               } else {
                   def imageTag = previousBuildNumber ?: 'latest'
                   env.IMAGE_TAG_VERSION = imageTag
                   echo "Previous build TAG set as env variable: ${env.IMAGE_TAG_VERSION}"
                   sh "sudo docker rmi devsahamerlin/tasksapp:${env.IMAGE_TAG_VERSION} -f"
               }
            }
          }
        }
        stage('Clean existing containers') {
            steps {
               script {
                  sh '''
                  if [ ! "$(docker ps -a -q -f name=tasksapp)" ]; then
                      echo "Found running container ID"
                      if [ "$(docker ps -aq -f name=tasksapp)" ]; then
                          echo "Found running container"
                          docker rm -f $(sudo docker ps -aq)
                      else
                        echo "No matching container found."
                      fi
                  fi'''
               }
            }
        }
        stage ('checkout scm') {
            steps {
                script {
                    git branch: 'jenkins-oci-devsecops',
                    credentialsId: 'github-user-credentials',
                    url: 'https://github.com/devsahamerlin/iac-spring-boot-atp.git'
                }
            }
        }
        stage ('maven compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage ('maven Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=iac-spring-boot-atp \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=org.devsahamerlin.appengine:iac-spring-boot-atp '''
                }
            }
        }
        stage("quality gate"){
            steps {
                script {
                  waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
           }
        }
        stage ('Build Jar file'){
            steps{
                sh 'mvn clean install -DskipTests=true'
            }
        }

        stage('TRIVY FS SCAN') {
           steps {
               sh "trivy fs . > trivyfs.txt"
           }
        }

        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format XML ', odcInstallation: 'DPD-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Build and Push Docker Image') {
           environment {
             DOCKER_IMAGE = "devsahamerlin/tasksapp:${BUILD_NUMBER}"
             REGISTRY_CREDENTIALS = credentials('docker')
           }
           steps {
             script {
                sh "cp -r /home/ubuntu/wallet_oci_atp_db_cicd_app target"
                sh "tree"
                "sudo docker images | grep devsahamerlin/tasksapp*"
                sh "sudo docker build -t ${DOCKER_IMAGE} ."
                def dockerImage = docker.image("${DOCKER_IMAGE}")
                 docker.withRegistry('https://index.docker.io/v1/', "docker") {
                     dockerImage.push()
                 }
             }
           }
        }
        stage("TRIVY DOCKER IMAGE SCAN"){
            steps{
                sh "trivy image devsahamerlin/tasksapp:${BUILD_NUMBER} > trivy.txt"
            }
        }

        stage ('Deploy to container'){
            steps{
                sh "sudo docker rmi devsahamerlin/tasksapp:${env.IMAGE_TAG_VERSION} -f"
                sh "docker run -d --name tasksapp -p 8083:8082 devsahamerlin/tasksapp:${BUILD_NUMBER}"
            }
        }

        stage('Update Deployment File') {
                environment {
                    GIT_REPO_NAME = "iac-spring-boot-atp"
                    GIT_USER_NAME = "devsahamerlin"
                }
                steps {
                    withCredentials([string(credentialsId: 'gitops-user-secret-text', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                            git config user.email "devsahamerlin@gmail.com"
                            git config user.name "Saha Merlin"
                            BUILD_NUMBER=${BUILD_NUMBER}
                            sed -i "s/${IMAGE_TAG_VERSION}/${BUILD_NUMBER}/g" devops/manifests/deployment.yml
                            git add devops/manifests/deployment.yml
                            git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                            git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:jenkins-oci-devsecops
                        '''
                    }
                }
        }
    }
}