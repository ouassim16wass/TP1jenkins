pipeline {
    agent any

    environment {
        CONTAINER_ID = ""
        SUM_PY_PATH = "./sum.py"
        DIR_PATH = "./"
        TEST_FILE_PATH = "./test_variables.txt"
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t sum-python-image .'
            }
        }

        stage('Run') {
            steps {
                echo 'Running Docker container...'
                script {
                    def output = sh(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    env.CONTAINER_ID = output
                    echo "Container ID: ${env.CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Testing the Python script...'
                script {
                    def testLines = readFile(env.TEST_FILE_PATH).split('\n')
                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = sh(script: "docker exec ${env.CONTAINER_ID} python /app/sum.py ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.toFloat()

                        if (result == expectedSum) {
                            echo "Test passed: ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "Test failed: ${arg1} + ${arg2} != ${result} (Expected: ${expectedSum})"
                        }
                    }
                }
            }
        }

        stage('Deploy to DockerHub') {
            steps {
                echo 'Deploying to DockerHub...'
                sh 'docker login -u wassim33 -p Wa2sim1611'
                sh 'docker tag sum-python-image wassim33/sum-python-image:latest'
                sh 'docker push wassim33/sum-python-image:latest'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker stop ${env.CONTAINER_ID} || true'
            sh 'docker rm ${env.CONTAINER_ID} || true'
        }
    }
}
