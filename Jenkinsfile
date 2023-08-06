pipeline {
  agent any 

  tool {
    jdk ''
    maven ''
  }

  parameters {
    // string(name: 'DOCKER_REGISTRY', defaultValue: '', description: 'URI of ECR repository')
    string(name: 'IMAGE_TAG', defaultValue: 'develop', description: 'Tag of Docker Image')
    string(name: 'GIT_REPO_URL', defaultValue: 'https://gitlab.com/duy-prog/discovery-server.git', description: 'Github repo to clone')
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
          userRemoteConfig: [[credentialsId:'4174258f-02a6-4a1e-b1e3-324154d8c9a9', url: '${GIT_REPO_URL}']]])
      }
    }

    // stage("Build Application") {
    //   steps {
    //     sh "mvn package -DskipTests"
    //   }
    // }

    // stage("Build Docker Image") {
    //   step {
    //     sh "docker build . -t $DOCKER_REGISTRY:$IMAGE_TAG"
    //   }
    // }

    // stage("Push Docker Image") {
    //   steps {
    //     sh "docker login --username ${ECR_CREDENTIAL_USR} -p ${ECR_CREDENTIAL_PWS}"
    //     sh "docker push $DOCKER_REGISTRY:$IMAGE_TAG"
    //   }
    // }

    // stage("Cleaning up") {
    //   steps {
    //     sh "docker rmi $DOCKER_REGISTRY:$IMAGE_TAG"
    //   }
    // }
    post {
      always {
        deleteDir()
      }
    }
  }
}