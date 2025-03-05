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
    stage('Deploy') {
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
            def ec2Ip = "52.221.204.144"
            def appName = "my-app.jar"

            // Upload JAR file to EC2
            sh """
                scp -i \$SSH_KEY -o StrictHostKeyChecking=no target/*.jar ec2-user@${ec2Ip}:~/app/${appName}
            """

            // Restart application on EC2
            sh """
                ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ec2-user@${ec2Ip} << EOF
                pkill -f ${appName} || true
                nohup java -jar ~/app/${appName} > ~/app/app.log 2>&1 &
                EOF
            """
        }
    }

}