pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-node-app .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run -d -p 3000:3000 --name test-node-app my-node-app'
                }
            }
        }
        stage('Wait for Node.js App to Start') {
            steps {
                script {
                    def started = false
                    for (int i = 0; i < 20; i++) {
                        def status = sh(script: "docker exec test-node-app curl -s http://localhost:3000 > /dev/null", returnStatus: true)
                        if (status == 0) {
                            echo "App is reachable!"
                            started = true
                            break
                        }
                        echo "Waiting for app to be reachable..."
                        sleep 3
                    }
                    if (!started) {
                        sh 'docker logs test-node-app'
                        error("App failed to start")
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                sh 'docker stop test-node-app || true'
                sh 'docker rm test-node-app || true'
                sh 'docker rmi my-node-app || true'
            }
        }
    }
}