# FULLSTACK TEMPLATE 

A FAIRE DESCRIPTION 



# Créer le .env pour le docker-compose

Copier le fichier example et générer un token JWT secret(à ne pas partager!!!), dans le terminal.

```bash
cp .env.example .env
# Generer un token aléatoire JWT secret
printf 'JWT_SECRET=%s\n' "$(openssl rand -base64 64 | tr -d '\n')" >> .env
```
Cette commande ajoute la ligne `JWT_SECRET=` ( plus clé secrête généré) à la fin du ficheir .env

Le `.env` avant:
```
DB_HOST=postgres
DB_PORT=5432
DB_NAME=devdb
DB_USERNAME=dev
DB_PASSWORD=dev
JWT_EXPIRATION_MS=3600000

```
La ligne à la fin est rajouté pour permettre à la commande au dessus de bien rajouter la ligne JWT

Le `.env` devrait ressembler à :
```
DB_HOST=postgres
DB_PORT=5432
DB_NAME=devdb
DB_USERNAME=dev
DB_PASSWORD=dev
JWT_EXPIRATION_MS=3600000
JWT_SECRET=<clé-generé>
```


# Stack technique

## Backend

* Java
* Spring Boot 4
* Spring Data JPA
* Spring Web
* Spring Security
* Maven

## Frontend

* Angular
* TypeScript

Télécharger la dernière version stable de node sur : https://nodejs.org/en/download
Choisir la version LTS (Long Term Support), la version maintenue. Suivre les etapes

## Base de données

* PostgreSQL

## Conteneurisation

* Docker
* Docker Compose


## Plugins recommandés

* Docker


---

# Installation

1. Cloner le dépôt.

```bash
git clone <repository-url>
```

2. Ouvrir le projet avec vsCode ou autre IDE.

3. Lancer Docker. Dans un terminal lancer : 
```bash
docker compose up -d 
```
```bash
docker compose build --no-cache frontend && docker compose up -d frontend
```

4. Démarrer Docker Deskstop. Qui va lancer le frontend et le backend

```bash
docker compose up -d
```

5. (sinon) Lancer le backend Spring Boot.
```bash
mvn spring-boot:run
```

6. (sinon) Lancer le frontend Angular.

```bash
npm install
ng serve
```

---

# Lancement

Une fois les deux applications démarrées :

- **Frontend** on `http://localhost:4200`
- **Backend** on `http://localhost:8080`
- **PostgreSQL** on `localhost:5432` (database `devdb`, user `dev`, password `dev`)

### Arreter le projet

En ligne de commande : 
```bash
docker compose down
```

Ou dans Docker Desktop directement.

Supprimer tous les volumes de la base de données :

```bash
docker compose down -v
```

## Structure du projet

```
fullstack-template/
├── backend/      # Spring Boot (Maven)
├── frontend/     # Angular
├── docker-compose.yml
├── .env.example         # Variables d'environnement
└── README.md
```