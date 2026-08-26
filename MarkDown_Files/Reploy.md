# RUN THE auto_deploy.sh for fast deployment

```bash
# give access to the auto_deploy file
chmod +x auto_deploy.sh && ./auto_deploy.sh
```

```
# on cmdr run the file
sh auto_deploy.sh
```

It will prompt the proxmox password when the frontend, backend and docker files are sent. So it will prompt the password 3 times.

Then prompt the password for the the ssh into proxmox.

the .env file is pushed on github and should be pull on proxmox. Or copy it over manually !!


# IF I want to deploy manually one by one :  OPEN 5 cmdr TERMINALS : steps to redeploy

## FIRST : frontend
```bash
docker build -t boycott-list-frontend:latest . && docker save boycott-list-frontend:latest -o frontend.tar && scp frontend.tar root@192.168.1.55:/opt/boycott-list/
```

## SECOND : backend
```bash
docker build -t boycott-list-backend:latest . && docker save boycott-list-backend:latest -o backend.tar && scp backend.tar root@192.168.1.55:/opt/boycott-list/
```

## THIRD : open a terminal at the root of the project, to send the docker compose
```bash
scp docker-compose-prod.yml root@192.168.1.55:/opt/boycott-list/
```

## FOURTH : ssh into dialloPavillion `ssh root@192.168.1.55`
```bash
pct push 113 /opt/boycott-list/backend.tar /opt/boycott-list/backend.tar && pct push 113 /opt/boycott-list/frontend.tar /opt/boycott-list/frontend.tar && pct push 113 /opt/boycott-list/docker-compose.yml /opt/boycott-list/docker-compose.yml && pct push 113 /opt/boycott-list/docker-compose-prod.yml /opt/boycott-list/docker-compose-prod.yml
```

## On Proxmox : if the .env file was modified, go to web version proxmox LXC

to edit .env file I must be on web proxmox not via ssh


nano `.env` to edit the file
```dotenv
DB_NAME=devdb
DB_USERNAME=dev
DB_PASSWORD=dev
APP_SECURITY_COOKIE_SECURE=false
JWT_SECRET=<long-random-secret>

DISCORD_WEBHOOK_URL=xxxxxx
NOTIFICATION_EMAIL_TO=doctor.games235@gmail.com
SPRING_MAIL_HOST=smtp.gmail.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=doctor.games235@gmail.com
SPRING_MAIL_PASSWORD=<pass-word>
SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH=true
SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE=true
```

## FIFTH : ssh into the boycott list container, when on ssh dialloPavillion `ssh root@192.168.1.55`
```bash
pct enter 113
cd /opt/boycott-list

# to delete the volumes and really strip clean everything :
docker compose down -v

docker-compose down && docker load -i frontend.tar && docker compose -f docker-compose-prod.yml up -d frontend && docker load -i backend.tar && docker compose -f docker-compose-prod.yml up -d backend
```

If there are issue, then force rebuild :
```bash
docker compose up -d --force-recreate backend
docker compose down && docker compose -f docker-compose-prod.yml -d --build
```

Check logs :
```bash
# check that all is running
docker ps

# check logs
docker logs backend_boycott_list
docker logs frontend_boycott_list
```


