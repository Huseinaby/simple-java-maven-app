node {
    stage('Checkout') {
        checkout scm
    }
    stage('Build') {
        docker.image('maven:latest').inside('-v /root/.m2:/root/.m2') {
            echo 'Building...'
            sh 'mvn -B -DskipTests clean package'
        }
    }
    stage('Test') {
        docker.image('maven:latest').inside('-v /root/.m2:/root/.m2') {
            echo 'Testing...'
            sh 'mvn test'
            junit 'target/surefire-reports/*.xml'
        }
    }
    stage('Manual Approval') {
        docker.image('maven:latest').inside('-v /root/.m2:/root/.m2') {
            input message: 'Lanjutkan ke tahap Deploy?'
        }
    }
    stage('Deploy') {
        docker.image('maven:latest').inside('-v /root/.m2:/root/.m2') {
            echo 'Deploying ...'
            sh './jenkins/scripts/deliver.sh'
            sleep time: 1, unit: 'MINUTES'
        }
    }
}
