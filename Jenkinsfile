pipeline {
  agent any 

  tools {
    maven '3.9.4'
  }

  parameters {
    string(name: 'DOCKER_REGISTRY', defaultValue: '099608707772.dkr.ecr.ap-southeast-1.amazonaws.com/discovery-server', description: 'URI of ECR repository')
    string(name: 'BRANCH_NAME', defaultValue: 'develop', description: 'Branch name of git repo')
    string(name: 'GIT_REPO_URL', defaultValue: 'https://gitlab.com/duy-prog/discovery-server.git', description: 'Github repo to clone')
    string(name: 'APP_VERSION', description: 'Version of application')
  }

  environment {
    TEMPLATE_PATH = "/home/jenkins-admin/trivy_template/html.tpl"
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
          userRemoteConfigs: [[credentialsId:'10d46ee2-0081-4fd7-a4dc-e623867268cc', url: '${GIT_REPO_URL}']],
          submoduleCfg: []
        ])
      }
    }

    stage("SonarQube Scan"){
      steps {
        withSonarQubeEnv(installationName: 'sq1'){
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=discovery-server -Dsonar.projectName='discovery-server'"
        }
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
      steps {
        sh "docker build --no-cache -t $DOCKER_REGISTRY:$APP_VERSION ."
      }
    }

    stage("Image Scan") {
      steps {
        sh "trivy image --format template --template ${TEMPLATE_PATH} \
        --scanners vuln --no-progress --exit-code 0 --severity HIGH,CRITICAL \
        --timeout 15m --output cve_report.html $DOCKER_REGISTRY:$APP_VERSION"
      }
    }

    stage("Push Docker Image") {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: "aws-duypk5",
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'    
        ]]){
          sh "aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 099608707772.dkr.ecr.ap-southeast-1.amazonaws.com"  
          sh "docker push $DOCKER_REGISTRY:$APP_VERSION"
        }
      }
    }

    stage("Cleaning up") {
      steps {
        sh "docker rmi -f $DOCKER_REGISTRY:$APP_VERSION"
      }
    }
  }
  post {
    always {
      archiveArtifact artifacts: "cve_report.html", fingerprint: true 
      publishHTML(target: [
        allowMissing: false, 
        alwaysLinkToLastBuild: false, 
        keepAll: true, 
        reportDir: '.',
        reportFiles: 'cve_report.html',
        reportName: 'Trivy CVE Report'
      ])
      deleteDir()
    }
  }  
}