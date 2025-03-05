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
        input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed'
    }

    stage('Build Docker Image') {
    withCredentials([usernamePassword(credentialsId: 'docker-hub-user', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh '''
        ls -lah target/
        cp target/my-app-1.0-SNAPSHOT.jar app.jar
        ls -lah app.jar

        cat > Dockerfile <<EOF
        FROM openjdk:11-jre-slim
        COPY app.jar /app.jar
        ENTRYPOINT ["java", "-jar", "/app.jar"]
        EOF

        docker build -t $USER/hello-world-java-app:latest .
        docker images
        '''
    }
}

}

    stage('Push to Docker Hub') {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-user', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
            sh '''
            echo $PASS | docker login -u $USER --password-stdin
            docker push $USER/hello-world-java-app:latest
            '''
        }
    }

    stage('Deploy to EC2') {
        sshagent(['ec2-ssh-key']) {
            sh '''
            ssh -o StrictHostKeyChecking=no ubuntu@$EC2_IP << 'EOF'
            
            if ! command -v docker &> /dev/null; then
                echo "Docker tidak ditemukan, menginstal Docker..."
                sudo apt update
                sudo apt install -y docker.io
                sudo systemctl enable docker
                sudo systemctl start docker
            fi

            sudo docker pull $USER/hello-world-java-app:latest

            docker ps -a | grep hello-world-java-container && docker stop hello-world-java-container && docker rm hello-world-java-container || echo "Container not found, skipping removal."

            sudo docker run -d --name hello-world-java-container -p 8080:8080 $USER/hello-world-java-app:latest

            echo "Container sudah berjalan di EC2"
EOF
            '''
        }
    }

    stage('Done') {
        echo 'Pipeline selesai'
    }
}