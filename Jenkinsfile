def ssh_key = '/var/jenkins_home/Java-maven-app.pem'
def ec2_user = 'ubuntu'
def ec2_ip = '52.221.204.144'  

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
        docker.image('maven:latest').inside('-v /root/.m2:/root/.m2 -v /var/jenkins_home/Java-maven-app.pem:/root/Java-maven-app.pem') {
            echo 'Deploying ...'
            
             echo 'Uploading JAR to EC2...'
        sh """scp -i "${ssh_key}" -o StrictHostKeyChecking=no target/my-app-1.0-SNAPSHOT.jar ${ec2_user}@${ec2_ip}:/home/ubuntu/
        """

        echo 'Running app on EC2...'
        sh """
            ssh -i "${ssh_key}" -o StrictHostKeyChecking=no ${ec2_user}@${ec2_ip} '
                nohup java -jar /home/ubuntu/my-app-1.0-SNAPSHOT.jar > app.log 2>&1 &
            '
        """

            sleep time: 1, unit: 'MINUTES'
        }
    }
}
