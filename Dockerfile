# Utiliser l'image Python officielle
FROM python:3.13.0-alpine3.20

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le script sum.py dans le conteneur
COPY sum.py .

# Assurer que le conteneur reste actif
CMD ["tail", "-f", "/dev/null"]
