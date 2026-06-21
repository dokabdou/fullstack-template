# Full‑Stack Template: Angular + Spring Boot + MongoDB + JPA + Security

A ready‑to‑clone starter for full‑stack projects with an **Angular** front‑end, a **Spring Boot** back‑end, and support for both **MongoDB** (NoSQL) and **JPA / H2** (relational) databases. Spring Security is pre‑configured with basic authentication.

Use this repository as a template to bootstrap new projects quickly – just clone, rename a few things, and start coding.

---

## 🧰 Tech Stack

| Layer      | Technology                         |
|------------|------------------------------------|
| Frontend   | Angular (latest)                   |
| Backend    | Java 25+, Spring Boot 3.x          |
| Security   | Spring Security (Basic Auth)       |
| Databases  | MongoDB + H2 (JPA) – easily swap to PostgreSQL/MySQL |
| Build Tool | Maven                              |
| Proxying   | Angular CLI proxy (dev mode)       |

---

## 📦 Prerequisites

Make sure you have these installed on your machine:

- **Java 25+**  
- **Node.js 18+** and npm  
- **Angular CLI** (`npm install -g @angular/cli`)  
- **MongoDB** (community edition – only if you actually use MongoDB)  
- **Git**

---

## 🚀 Getting Started

### 1. Clone the template

```bash
git clone https://github.com/your-org/fullstack-template.git my-new-project
cd my-new-project
```

### 2. Remove the existing Git history and start fresh

```bash
rm -rf .git
git init
git add .
git commit -m "Initial commit from fullstack template"
```

### 3. Rename project details (optional)

- In **Angular** (frontend): edit `angular.json` and `package.json` to change the project name.  
- In **Spring Boot** (backend): edit `pom.xml` (change `artifactId`, `groupId`, `name`, `description`) and update package names in Java files.

### 4. Start the back‑end

First, ensure MongoDB is running (skip if you don’t plan to use it, but the default config tries to connect).  
Then start the Spring Boot app:

```bash
cd backend
./mvnw spring-boot:run
```

The API will be available at `http://localhost:8080`.

### 5. Start the front‑end

Open a new terminal:

```bash
cd frontend
ng serve
```

The front‑end will be served at `http://localhost:4200`.  
All API calls to `/api/*` are automatically proxied to the back‑end.

---

## 📁 Project Structure

```
fullstack-template/
├── frontend/                 # Angular application
│   ├── src/
│   ├── angular.json
│   └── proxy.conf.json       # Dev proxy to backend
├── backend/                  # Spring Boot application
│   ├── src/main/java/...
│   │   ├── controller/       # REST endpoints (PingController, UserController)
│   │   ├── model/            # JPA entities (AppUser)
│   │   ├── repository/       # Spring Data repositories (JPA)
│   │   └── security/         # Security configuration
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
├── .gitignore
└── README.md
```

---

## 🔑 Default Endpoints & Authentication

| Method | URL                   | Auth Required | Description                              |
|--------|-----------------------|---------------|------------------------------------------|
| GET    | `/api/ping`           | No            | Public health‑check endpoint             |
| GET    | `/api/users`          | Yes           | Fetch all users (JPA/H2)                 |
| POST   | `/api/users`          | Yes           | Create a new user (JPA/H2)               |
| –      | `/h2-console`         | No*           | H2 database web console (dev only)       |

> *The H2 console is publicly accessible for development convenience; disable in production.*

Basic Auth credentials (for testing):  
`user` / `password`

Example (curl):

```bash
# Public ping
curl http://localhost:8080/api/ping

# Get users (requires auth)
curl -u user:password http://localhost:8080/api/users

# Create a user
curl -u user:password -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"username":"alice","email":"alice@example.com"}'
```

---

## 🗄️ Databases

By default, the back‑end uses **two** databases:

- **MongoDB**: `mongodb://localhost:27017/template_db` – ready for NoSQL data.
- **H2 (in‑memory)**: JDBC URL `jdbc:h2:mem:testdb` – automatically created, data lost on restart.  
  Accessible via the web console at `http://localhost:8080/h2-console` (driver: `org.h2.Driver`, user `sa`, empty password).

### Switching to a production database

To replace H2 with, for example, PostgreSQL:

1. Add the PostgreSQL driver to `pom.xml`:
   ```xml
   <dependency>
       <groupId>org.postgresql</groupId>
       <artifactId>postgresql</artifactId>
       <scope>runtime</scope>
   </dependency>
   ```
2. Update `application.properties`:
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
   spring.datasource.driver-class-name=org.postgresql.Driver
   spring.datasource.username=myuser
   spring.datasource.password=mypassword
   spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
   ```
3. Remove or disable the H2 dependency if you no longer need it.

To remove MongoDB completely, just comment out or delete the `spring.data.mongodb.uri` property and remove the `spring-boot-starter-data-mongodb` dependency from `pom.xml`.

---

## 🔐 Security Customisation

The default `SecurityConfig` uses HTTP Basic Authentication and an in‑memory user.  
To switch to JWT, database‑backed users, or OAuth2, modify `backend/src/main/java/com/example/backend/security/SecurityConfig.java`. The template provides a clean extension point.

---

## 📝 Using This as a GitHub Template

If you store this repo on GitHub, you can mark it as a **template repository** (Settings → check “Template repository”).  
Then anyone can click **“Use this template”** to generate a new repo instantly.

---

## 🧪 Future Ideas (Optional Enhancements)

- Add JWT authentication
- Replace Basic Auth with a login page (Angular + Spring Security)
- Use environment variables for database URIs
- Dockerise the whole stack
- Add Swagger/OpenAPI documentation
- Integrate Tailwind CSS or Angular Material

---

## 🤝 Contributing

Feel free to fork, open issues, or submit pull requests. This template is meant to evolve with your needs.

---

**Happy coding! 🚀**
```

Replace `https://github.com/your-org/fullstack-template.git` with your actual repository URL before committing.

To add it to your repository:

```bash
git add README.md
git commit -m "Add comprehensive README"
git push
```