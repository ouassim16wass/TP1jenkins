pipeline {
    agent any
    environment {
        IMAGE_NAME = 'wassim33/sum-python-image'
        CONTAINER_ID = ''
        TEST_FILE = 'test_variables.txt'
    }
    stages {
        stage('Build') {
            steps {
                echo "🔨 Construction de l'image Docker..."
                bat 'docker build -t sum-python-image .'
            }
        }
        stage('Run') {
            steps {
                script {
                    echo "🚀 Démarrage du conteneur..."
                    def output = bat(script: 'docker run -d sum-python-image', returnStdout: true).trim()
                    def lines = output.split('\n')
                    env.CONTAINER_ID = lines[lines.length - 1].trim()
                    echo "🆔 ID du conteneur: ${env.CONTAINER_ID}"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo "✅ Exécution des tests..."
                    def lines = readFile(TEST_FILE).split('\n')
                    for (line in lines) {
                        def args = line.split(' ')
                        def result = bat(script: "docker exec ${env.CONTAINER_ID} python /app/sum.py ${args[0]} ${args[1]}", returnStdout: true).trim()
                        echo "Test: ${args[0]} + ${args[1]} = ${result} (Attendu: ${args[2]})"
                        if (result != args[2]) {
                            error("❌ Test échoué: ${args[0]} + ${args[1]} != ${result}")
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo "📦 Déploiement de l'image sur DockerHub..."
                bat 'docker login -u wassim33 -p Wa2sim1611'
                bat 'docker tag sum-python-image wassim33/sum-python-image:latest'
                bat 'docker push wassim33/sum-python-image:latest'
            }
        }
    }
    post {
        always {
            script {
                if (env.CONTAINER_ID) {
                    echo "🛑 Arrêt et suppression du conteneur..."
                    bat "docker stop ${env.CONTAINER_ID}"
                    bat "docker rm ${env.CONTAINER_ID}"
                }
            }
        }
    }
}
