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
        echo 'Deploying to EC2...'
        
        def ec2User = 'ubuntu'  // Default user Ubuntu EC2
        def ec2Host = '52.221.204.144' // Ganti dengan IP publik EC2 kamu
        def pemKey = '/var/jenkins_home/Java-maven-app.pem' // Simpan key di Jenkins server
        def jarFile = 'target/my-app-1.0-SNAPSHOT.jar' // Ganti sesuai nama file JAR hasil build
        
        sh """
            chmod 400 ${pemKey}
            
            # Kirim JAR ke EC2
            scp -i ${pemKey} ${jarFile} ${ec2User}@${ec2Host}:/home/${ec2User}/app.jar
            
            # Jalankan aplikasi di EC2
            ssh -i ${pemKey} ${ec2User}@${ec2Host} '
                pkill -f app.jar || true
                nohup java -jar /home/${ec2User}/app.jar > app.log 2>&1 &
            '
        """
    }
}

}
