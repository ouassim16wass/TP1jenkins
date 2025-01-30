pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = '/app/sum.py'
        DIR_PATH = 'Dockerfile' 
        TEST_FILE_PATH = '/app/test_variables.txt' 
    }

    stages {
        stage('Build') {
            steps {
                script {
                    bat 'docker build -t sum-python-image .'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true)
                    CONTAINER_ID = output.trim()
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n')

                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(script: "docker exec ${CONTAINER_ID} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.toFloat()

                        if (result == expectedSum) {
                            echo "Test réussi : ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "Test échoué : ${arg1} + ${arg2} attendu ${expectedSum}, obtenu ${result}"
                        }
                    }
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
                bat "docker stop ${CONTAINER_ID}"
                bat "docker rm ${CONTAINER_ID}"
            }
        }
    }
}
