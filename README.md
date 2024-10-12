# Time Manager

## Description

Le projet **Time Manager** est une application web permettant de gérer le temps, composée d'une base de données, d'une API backend, et d'une interface utilisateur. Ce projet est développé en utilisant Docker pour orchestrer plusieurs conteneurs. 

### Structure des conteneurs :
- **PostgreSQL** : Base de données
- **Adminer** : Interface d'administration de la base de données
- **Phoenix** : Backend / API (utilisant Elixir)
- **Vue.js** : Frontend

---

## Prérequis

Avant de démarrer, assurez-vous d'avoir installé :
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

---

## Lancement du projet

1. Clonez le dépôt du projet :

    ```bash
    git clone "adresse_du_repo"
    ```

2. Rendez-vous dans le dossier du projet :

    ```bash
    cd nom_du_projet
    ```

3. Créez un fichier `.env` à la racine du projet avec les variables d'environnement suivantes :

    ```bash
    POSTGRES_USER="postgres"
    POSTGRES_PASSWORD="postgres"
    POSTGRES_HOST="postgres"
    POSTGRES_DB="time_manager_db"
    ```

4. Lancez le projet en production avec la commande suivante :

    ```bash
    docker compose up --build
    ```

    Cette commande va créer et lancer tous les conteneurs nécessaires (PostgreSQL, Adminer, Phoenix, Vue.js).

---

## Environnement de développement

Si vous souhaitez travailler sur une partie spécifique du projet (par exemple, seulement le backend ou le frontend), vous pouvez lancer un service particulier à l'aide de la commande suivante :

```bash
docker compose up --build nom_du_service
