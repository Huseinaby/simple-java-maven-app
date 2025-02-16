node {
    stage('Build') {
        docker.image('maven:3.9.0').inside('-v /root/.m2:/root/.m2') {
            echo 'Building...'
            sh 'mvn -B -DskipTests clean package'
        }
    }
    
    stage('Test') {
        docker.image('maven:3.9.0').inside('-v /root/.m2:/root/.m2') {
            echo 'Testing...'
            sh 'mvn test'
            junit 'target/surefire-reports/*.xml'
        }
    }

    
}
