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
            
             echo 'Uploading JAR to EC2...'
        sh """scp -i "${Java-maven-app.js}" -o StrictHostKeyChecking=no target/my-app-1.0-SNAPSHOT.jar ${ubuntu}@${52.221.204.144}:/home/ubuntu/
        """

        echo 'Running app on EC2...'
        sh """
            ssh -i "${Java-maven-app.js}" -o StrictHostKeyChecking=no ${ubuntu}@${52.221.204.144} '
                nohup java -jar /home/ubuntu/my-app-1.0-SNAPSHOT.jar > app.log 2>&1 &
            '
        """

            sleep time: 1, unit: 'MINUTES'
        }
    }
}
