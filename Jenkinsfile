pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        IMAGE_NAME = 'wassim33/sum-python-image'
        TEST_FILE = 'test_variables.txt'
    }
    stages {
        stage('Build') {
            steps {
                bat 'docker build -t sum-python-image .'
            }
        }
        stage('Run') {
            steps {
                script {
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    env.CONTAINER_ID = output.split('\n')[-1].trim()
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    def lines = readFile(TEST_FILE).split('\n')
                    for (line in lines) {
                        def args = line.split(' ')
                        def result = bat(script: "docker exec ${env.CONTAINER_ID} python /app/sum.py ${args[0]} ${args[1]}", returnStdout: true).trim()
                        if (result != args[2]) {
                            error("Test échoué: ${args[0]} + ${args[1]} != ${result}")
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                bat 'docker login -u wassim33 -p Wa2sim1611'
                bat 'docker tag sum-python-image wassim33/sum-python-image:latest'
                bat 'docker push wassim33/sum-python-image:latest'
            }
        }
    }
    post {
        always {
            bat 'docker stop ${env.CONTAINER_ID} && docker rm ${env.CONTAINER_ID}'
        }
    }
}
