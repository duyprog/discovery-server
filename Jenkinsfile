pipeline {
  agent any 

  tools {
    maven '3.9.4'
  }

  parameters {
    string(name: 'DOCKER_REGISTRY', defaultValue: 'test', description: 'URI of ECR repository')
    string(name: 'IMAGE_TAG', defaultValue: 'test', description: 'Tag of Docker Image')
    string(name: 'BRANCH_NAME', defaultValue: 'develop', description: 'Branch name of git repo')
    string(name: 'GIT_REPO_URL', defaultValue: 'https://gitlab.com/duy-prog/discovery-server.git', description: 'Github repo to clone')
  }

  // environment {

  // }

  stages {
    stage("Check environment") {
      steps {
        sh 'java -version'
        sh 'mvn --version'
        sh 'docker --version'
      }
    }

    stage("Checkout Source Code") {
      steps {
        checkout([
          $class: 'GitSCM', 
          branches: [[name: '${BRANCH_NAME}']], 
          userRemoteConfigs: [[credentialsId:'10d46ee2-0081-4fd7-a4dc-e623867268cc', url: '${GIT_REPO_URL}']],
          submoduleCfg: []
        ])
      }
    }

    stage("Build Application") {
      steps {
        sh "mvn package -DskipTests"
        sh "pwd"
        sh "ls"
      }
    }

    stage("Build Docker Image") {
      step {
        sh "docker build . -t $DOCKER_REGISTRY:$IMAGE_TAG"
      }
    }

    // stage("Push Docker Image") {
    //   steps {
    //     sh "docker login --username ${ECR_CREDENTIAL_USR} -p ${ECR_CREDENTIAL_PWS}"
    //     sh "docker push $DOCKER_REGISTRY:$IMAGE_TAG"
    //   }
    // }

    stage("Cleaning up") {
      steps {
        sh "docker rmi $DOCKER_REGISTRY:$IMAGE_TAG"
      }
    }
  }
  post {
    always {
      deleteDir()
    }
  }  
}