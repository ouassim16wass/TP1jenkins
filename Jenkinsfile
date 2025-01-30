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
                    // Lancer le conteneur
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    CONTAINER_ID = output

                    // Vérifier que le conteneur est bien en cours d'exécution
                    def psOutput = bat(script: "docker ps -q -f id=${CONTAINER_ID}", returnStdout: true).trim()
                    if (psOutput != CONTAINER_ID) {
                        error "Le conteneur n'est pas en cours d'exécution : ${CONTAINER_ID}"
                    }
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

                        // S'assurer que l'ID du conteneur est valide
                        echo "Exécution sur le conteneur ID : ${CONTAINER_ID}"
                        
                        // Exécution de la commande dans le conteneur
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
                // Arrêter et supprimer le conteneur après l'exécution
                bat "docker stop ${CONTAINER_ID}"
                bat "docker rm ${CONTAINER_ID}"
            }
        }
    }
}
