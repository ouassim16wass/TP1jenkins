pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = '/app/sum.py'
        DIR_PATH = 'Dockerfile'
        TEST_FILE_PATH = 'test_variables.txt'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ouassim16wass/TP1jenkins.git'
            }
        }

        stage('Build') {
            steps {
                bat 'docker build -t sum-python-image .'
            }
        }

        stage('Run') {
            steps {
                script {
                    // Lancer le conteneur en mode détaché et récupérer l'ID
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    CONTAINER_ID = output
                    echo "Conteneur lancé avec ID: ${CONTAINER_ID}"
                }
            }
        }

        

        stage('Deploy') {
            steps {
                script {
                    bat 'docker login -u wassim33 -p Wa2sim1611'
                    bat 'docker tag sum-python-image wassim33/sum-python-image:latest'
                    bat 'docker push wassim33/sum-python-image:latest'
                }
            }
        }
    }

    post {
        always {
            script {
                if (CONTAINER_ID) {
                    bat "docker stop ${CONTAINER_ID}"
                    bat "docker rm ${CONTAINER_ID}"
                }
            }
        }
    }
}
