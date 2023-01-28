pipeline {
    agent any

    stages {
        stage ("Build Docker Image") {
            steps {
                script {
                    dockerapp = docker.build("wesleyserrano/kube-news:${env.BUILD_ID}", "-f ./src/Dockerfile ./src")
                }
            }
        }

        stage ("Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('https://registry.docker.hub.com','dockerHub') {
                        dockerapp.push('latest')
                        dockerapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }
    }
}