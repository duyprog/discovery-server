pipeline {
  agent any 

  tool {
    jdk ''
    maven ''
  }

  parameters {
    string(name: 'DOCKER_REGISTRY', defaultValue: '', description: 'URI of ECR repository')
    string(name: 'IMAGE_TAG', defaultValue: '', description: 'Tag of Docker Image')
    string(name: 'GITHUB_REPO_URL', defaultValue: '', description: 'Github repo to clone')
  }

  environment {

  }

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
          userRemoteConfig: [[credentialsId:'jenkins-github', url: '${GITHUB_REPO_URL}']]])
      }
    }

    stage("Build Application") {
      steps {
        sh "mvn package -DskipTests"
      }
    }

    stage("Build Docker Image") {
      step {
        sh "docker build . -t $DOCKER_REGISTRY:$IMAGE_TAG"
      }
    }

    stage("Push Docker Image") {
      steps {
        sh "docker login --username ${ECR_CREDENTIAL_USR} -p ${ECR_CREDENTIAL_PWS}"
        sh "docker push $DOCKER_REGISTRY:$IMAGE_TAG"
      }
    }

    stage("Cleaning up") {
      steps {
        sh "docker rmi $DOCKER_REGISTRY:$IMAGE_TAG"
      }
    }
    post {
      always {
        deleteDir()
      }
    }
  }
}