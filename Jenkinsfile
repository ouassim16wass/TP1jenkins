pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = '/app/sum.py'
        DIR_PATH = 'Dockerfile' 
        TEST_FILE_PATH = 'fichiertest_variables.txt' 
    }

    stages {
        stage('Checkout') {
            steps {
                // Cloner votre dépôt GitHub
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
                    // Lancer le conteneur en mode détaché
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    CONTAINER_ID = output
                }
            }
        }

        stage('Test') {
            steps {
                script {
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
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Connexion au Docker Hub et déploiement de l'image
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
                // Arrêter et supprimer le conteneur Docker après l'exécution
                bat "docker stop ${CONTAINER_ID}"
                bat "docker rm ${CONTAINER_ID}"
            }
        }
    }
}
