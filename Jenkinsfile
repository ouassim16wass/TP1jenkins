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
                // Cloner le dépôt GitHub
                git 'https://github.com/ouassim16wass/TP1jenkins.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Construire l'image Docker
                    bat 'docker build -t sum-python-image .'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    // Lancer le conteneur en mode détaché et récupérer l'ID du conteneur
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    // Extraire seulement l'ID du conteneur
                    CONTAINER_ID = output.split('\r\n')[0].trim()
                    echo "Conteneur lancé avec ID: ${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Vérifier si le conteneur est en cours d'exécution avec l'ID
                    def checkContainer = bat(script: "docker ps -q --filter id=${CONTAINER_ID}", returnStdout: true).trim()

                    if (checkContainer) {
                        // Lire les variables de test depuis le fichier
                        def testLines = readFile(TEST_FILE_PATH).split('\n')

                        // Exécuter les tests pour chaque ligne
                        for (line in testLines) {
                            def vars = line.split(' ')
                            def arg1 = vars[0]
                            def arg2 = vars[1]
                            def expectedSum = vars[2].toFloat()

                            // Exécuter le script dans le conteneur Docker
                            def output = bat(script: "docker exec ${CONTAINER_ID} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                            def result = output.toFloat()

                            // Vérification du résultat
                            if (result == expectedSum) {
                                echo "Test réussi : ${arg1} + ${arg2} = ${result}"
                            } else {
                                error "Test échoué : ${arg1} + ${arg2} attendu ${expectedSum}, obtenu ${result}"
                            }
                        }
                    } else {
                        error "Le conteneur avec l'ID ${CONTAINER_ID} n'est pas en cours d'exécution."
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Connexion au Docker Hub
                    bat 'docker login -u wassim33 -p Wa2sim1611'

                    // Taguer l'image et pousser vers Docker Hub
                    bat 'docker tag sum-python-image wassim33/sum-python-image:latest'
                    bat 'docker push wassim33/sum-python-image:latest'
                }
            }
        }
    }

    post {
        always {
            script {
                // Arrêter et supprimer le conteneur Docker après l'exécution
                if (CONTAINER_ID) {
                    bat "docker stop ${CONTAINER_ID}"
                    bat "docker rm ${CONTAINER_ID}"
                }
            }
        }
    }
}
