# Successful log of boycott-list : auto_deploy - Send docker images to Proxmox

Here is the log that shows that the script works.

```bash
C:\Users\Abdou\Documents\Codes\boycott-list (main -> origin) (fullstack-template)
λ sh auto_deploy.sh
�  Building frontend image...
[+] Building 40.0s (13/13) FINISHED                                                              docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                             0.0s
 => => transferring dockerfile: 531B                                                                             0.0s
 => [internal] load metadata for docker.io/library/node:22-alpine                                                0.9s
 => [auth] library/node:pull token for registry-1.docker.io                                                      0.0s
 => [internal] load .dockerignore                                                                                0.0s
 => => transferring context: 2B                                                                                  0.0s
 => [build 1/6] FROM docker.io/library/node:22-alpine@sha256:c610fcdfb1d5b4740dd70c284ed3cb16bb857e0f7166196e36  0.0s
 => => resolve docker.io/library/node:22-alpine@sha256:c610fcdfb1d5b4740dd70c284ed3cb16bb857e0f7166196e36a5501d  0.0s
 => [internal] load build context                                                                                1.6s
 => => transferring context: 1.98MB                                                                              1.6s
 => CACHED [build 2/6] WORKDIR /app                                                                              0.0s
 => CACHED [build 3/6] COPY package*.json ./                                                                     0.0s
 => CACHED [build 4/6] RUN npm ci                                                                                0.0s
 => [build 5/6] COPY . .                                                                                        11.7s
 => [build 6/6] RUN npm run build                                                                               23.1s
 => [stage-1 3/3] COPY --from=build /app/dist ./dist                                                             0.1s
 => exporting to image                                                                                           0.6s
 => => exporting layers                                                                                          0.3s
 => => exporting manifest sha256:3d025cac2778439c7b9ec478a4217af839ed58970c67e9cfc3332e215c99901d                0.0s
 => => exporting config sha256:ece40dd59988ce90a7d1749db5e5d98a8708ad4531b2c31a556b1758a84d5613                  0.0s
 => => exporting attestation manifest sha256:1816ce8b941218422926577763a125b8d77c2493810b8b435b8d155a664985ed    0.0s
 => => exporting manifest list sha256:bb730c3e78bc359c70642a6e49f0d94bb747f5a630438ffe145a5d4b0e68bbc5           0.0s
 => => naming to docker.io/library/boycott-list-frontend:latest                                                  0.0s
 => => unpacking to docker.io/library/boycott-list-frontend:latest                                               0.1s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/rcd6q7s29bvbzzmn6cgilft77
� Uploading frontend.tar to Proxmox host...
root@192.168.1.55's password:
frontend.tar                                                                        100%   56MB   1.4MB/s   00:39
�  Building backend image...
[+] Building 1.8s (17/17) FINISHED                                                               docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                             0.0s
 => => transferring dockerfile: 569B                                                                             0.0s
 => [internal] load metadata for docker.io/library/eclipse-temurin:25-jdk                                        1.1s
 => [internal] load metadata for docker.io/library/maven:3.9-eclipse-temurin-25                                  1.1s
 => [auth] library/maven:pull token for registry-1.docker.io                                                     0.0s
 => [auth] library/eclipse-temurin:pull token for registry-1.docker.io                                           0.0s
 => [internal] load .dockerignore                                                                                0.0s
 => => transferring context: 2B                                                                                  0.0s
 => [build 1/6] FROM docker.io/library/maven:3.9-eclipse-temurin-25@sha256:d67198007bb4441b07d45587320f83154de8  0.1s
 => => resolve docker.io/library/maven:3.9-eclipse-temurin-25@sha256:d67198007bb4441b07d45587320f83154de80ece36  0.1s
 => [internal] load build context                                                                                0.0s
 => => transferring context: 4.66kB                                                                              0.0s
 => [stage-1 1/3] FROM docker.io/library/eclipse-temurin:25-jdk@sha256:e787e08ef76f4c16866108cd7f9fcd96a68eef3a  0.1s
 => => resolve docker.io/library/eclipse-temurin:25-jdk@sha256:e787e08ef76f4c16866108cd7f9fcd96a68eef3ac6cc7686  0.1s
 => CACHED [stage-1 2/3] WORKDIR /app                                                                            0.0s
 => CACHED [build 2/6] WORKDIR /app                                                                              0.0s
 => CACHED [build 3/6] COPY pom.xml .                                                                            0.0s
 => CACHED [build 4/6] RUN mvn dependency:go-offline -B                                                          0.0s
 => CACHED [build 5/6] COPY src ./src                                                                            0.0s
 => CACHED [build 6/6] RUN mvn clean package -DskipTests                                                         0.0s
 => CACHED [stage-1 3/3] COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar                        0.0s
 => exporting to image                                                                                           0.2s
 => => exporting layers                                                                                          0.0s
 => => exporting manifest sha256:610796a915f70648f2b4f014134ebe529aa15de52a27f9e3f933dd617d5f2ea4                0.0s
 => => exporting config sha256:73aa068a2743d3056825a064f6d5e8514738791961b6690bffc711e591ab79f5                  0.0s
 => => exporting attestation manifest sha256:43059b7bf10c223c6e24333ff931c522fc88f50e4873729627394871a951eb9d    0.1s
 => => exporting manifest list sha256:84589323cabe3dcac1050148422d79e42e7a042a3c48ede7c724c225f3a68e5e           0.0s
 => => naming to docker.io/library/boycott-list-backend:latest                                                   0.0s
 => => unpacking to docker.io/library/boycott-list-backend:latest                                                0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/knohq633andrwejyp5f0fb18g
� Uploading backend.tar to Proxmox host...
root@192.168.1.55's password:
backend.tar                                                                         100%  200MB   1.4MB/s   02:22
� Copying docker-compose files...
root@192.168.1.55's password:
docker-compose-prod.yml                                                             100% 2157    49.0KB/s   00:00
� Pushing files into LXC 113...
Pseudo-terminal will not be allocated because stdin is not a terminal.
root@192.168.1.55's password:
Linux dialloPavillion 6.17.4-2-pve #1 SMP PREEMPT_DYNAMIC PMX 6.17.4-2 (2025-12-19T07:49Z) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
� Deploying new images inside LXC 113...
root@192.168.1.55's password:
Stopping backend_boycott_list    ...
Stopping boycott-list-postgres-1 ...
Stopping frontend_boycott_list   ...
Stopping backend_boycott_list    ... done
Stopping boycott-list-postgres-1 ... done
Stopping frontend_boycott_list   ... done
Removing backend_boycott_list    ...
Removing boycott-list-postgres-1 ...
Removing frontend_boycott_list   ...
Removing boycott-list-postgres-1 ... done
Removing backend_boycott_list    ... done
Removing frontend_boycott_list   ... done
Removing network boycott-list_internal-app-network
Network proxy-network is external, skipping
Loaded image: boycott-list-frontend:latest
Creating network "boycott-list_internal-app-network" with driver "bridge"
Creating frontend_boycott_list ...
Creating frontend_boycott_list ... done
Loaded image: boycott-list-backend:latest
Creating boycott-list_postgres_1 ...
Creating boycott-list_postgres_1 ... done
Creating backend_boycott_list    ...
Creating backend_boycott_list    ... done
✅ Redeployment complete!
```

