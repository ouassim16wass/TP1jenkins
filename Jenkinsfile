pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = '/app/sum.py'
        DIR_PATH = 'Dockerfile' 
        TEST_FILE_PATH = 'test_variables.txt' 
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
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    CONTAINER_ID = output
                    echo "Container ID: ${CONTAINER_ID}"
                    
                    // Vérifie que le conteneur est en cours d'exécution
                    bat "docker ps -q --filter id=${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n')
                    def allTestsPassed = true

                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        try {
                            def output = bat(script: "docker exec ${CONTAINER_ID} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                            def result = output.toFloat()

                            if (result == expectedSum) {
                                echo "Test réussi : ${arg1} + ${arg2} = ${result}"
                            } else {
                                echo "Test échoué : ${arg1} + ${arg2} attendu ${expectedSum}, obtenu ${result}"
                                allTestsPassed = false
                            }
                        } catch (Exception e) {
                            echo "Erreur lors de l'exécution du te
