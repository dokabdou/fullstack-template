# FULLSTACK TEMPLATE

TO DO DESCRIPTION

Rename the frontend and backend to the project name -- RENAME everything thats name "fullstack-template" :
Search for {PROJECT_NAME}- as well
- backend pom.xml, anywhere with 'frontend'
- frontend angular.json, anywhere with 'frontend'
- in the docker files front and back

Generate QR CODE in linux terminal or cmdr : 
```
curl -o PROJECT_NAME.png "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=https%3A%2F%2F{PROJECT}.abdoudiallo.fr%2F"
```


# Fill in the auto_deploy file for easier file transfers to proxmox
The info to fill in is the container id and relevant data

# Create the .env for docker-compose

Copy the example file and generate a secret JWT token (do not share it!!!), in the terminal.

```bash
cp .env.example .env
# Generate a random JWT secret token
printf 'JWT_SECRET=%s\n' "$(openssl rand -base64 64 | tr -d '\n')" >> .env
```
This command adds the line `JWT_SECRET=` (plus the generated secret key) to the end of the .env file

The `.env` before:
```
DB_HOST=postgres
DB_PORT=5432
DB_NAME=devdb
DB_USERNAME=dev
DB_PASSWORD=dev
JWT_EXPIRATION_MS=3600000

```
The line at the end is added to allow the above command to properly append the JWT line.

The `.env` should look like:
```
DB_HOST=postgres
DB_PORT=5432
DB_NAME=devdb
DB_USERNAME=dev
DB_PASSWORD=dev
JWT_EXPIRATION_MS=3600000
JWT_SECRET=<generated-key>
```

# Technical Stack

**Tech Stack:**

- **Backend:** Spring Boot 3.4 (Java 21) + Spring Security + JWT + MongoDB
- **Frontend:** Angular 19+ with Server‑Side Rendering (SSR) and an Express proxy
- **Database:** MongoDB 7.0
- **Deployment:** Docker Compose on a Proxmox LXC container


## Backend

* Java
* Spring Boot 4
* Spring Data JPA
* Spring Web
* Spring Security
* Maven

INFO : 

## Frontend

* Angular
* TypeScript

INFO : https://nodesource.com/products/distributions 

Download the latest stable version of Node from: https://nodejs.org/en/download
Choose the LTS (Long Term Support) version, the maintained version. Follow the steps.

## Database

* PostgreSQL

## Containerization

* Docker
* Docker Compose

## Recommended Plugins

* Docker

---

# Installation

1. Clone the repository.

```bash
git clone <repository-url>
```

2. Open the project with VS Code or another IDE.

3. Start Docker. In a terminal run:
```bash
docker compose up -d 
```
```bash
docker compose build --no-cache frontend && docker compose up -d frontend
```

4. Start Docker Desktop. It will launch the frontend and backend.

```bash
docker compose up -d
```

5. (otherwise) Start the Spring Boot backend.
```bash
mvn spring-boot:run
```

6. (otherwise) Start the Angular frontend.

```bash
npm install
ng serve
```

---

# Running

Once both applications are started:

- **Frontend** at `http://localhost:4200`
- **Backend** at `http://localhost:8080`
- **PostgreSQL** at `localhost:5432` (database `devdb`, user `dev`, password `dev`)

### Stopping the project

In the command line:
```bash
docker compose down
```

Or directly in Docker Desktop.

Remove all database volumes:

```bash
docker compose down -v
```

## Project Structure

```
fullstack-template/
├── backend/      # Spring Boot (Maven)
├── frontend/     # Angular
├── docker-compose.yml
├── .env.example         # Environment variables
└── README.md
```

## URL SET UP WITH NGINX AND Cloudflare

### Adding a new secure reverse proxy
On the local machine (with tailscale active) terminal :
```bash
ssh connect : ssh -L 81:10.10.10.7:81 root@192.168.1.55

-- ---- -----
10.10.10.7:81 => login in browser
doctorabdou235@keemail.me //password in notes
```

Proxy Host set up - on website::

- Click the Add Proxy Host button on the right.
- Fill out the Details tab exactly like this:
- Domain Names: Enter a domain name : NEWAPP.abdoudiallo.fr
- Scheme: http
- Forward Hostname / IP: 10.10.10.13 ==> the destination is going to be http://10.10.10.13:4200
- Forward Port: 4200
- toggle options then save
==> for future webapps just add a proxy host

### Adding url to Cloudflare 

Add the Subdomain to Cloudflare Zero Trust:
- Go to Cloudflare -> Zero Trust -> Networks -> Tunnels.
- Click on existing `Proxmox-Server` tunnel and hit EDIT.
- add route then Add published application
- add the subdomain name : NEWAPP
- Domain: abdoudiallo.fr
- **Service:** `HTTP` -> `10.10.10.7:80` :: “http://10.10.10.7:80”
    - *(Crucial: Always point the tunnel to the Nginx Proxy Manager IP, NOT the new app's IP!)*

AFTER ALL THIS THE APP IS NOW ACCESSIBLE ON : [NEWAPP.abdoudiallo.fr](https://NEWAPP.abdoudiallo.fr/)