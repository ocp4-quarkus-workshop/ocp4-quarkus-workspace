# Quarkus Workshop - Workspace

- bit.ly/qsh-wks-2023

## Quarkus Super-Heroes Workshop

- https://quarkus.io/quarkus-workshops/super-heroes/
- https://github.com/quarkusio/quarkus-workshops/
- https://github.com/quarkusio/quarkus-super-heroes


- https://github.com/ocp4-quarkus-workshop/ocp4-quarkus-workspace


- https://www.youtube.com/watch?v=KzIKGEsXQxg
- https://www.youtube.com/watch?v=7M0Tvlx-GTA
- https://www.youtube.com/watch?v=gyOe-m-kltw
- https://www.youtube.com/watch?v=421h2h9OUFY
- https://github.com/vaibhavjain4/quarkus-super-heroes
- https://drive.google.com/file/d/14J6EUZpDsUzpdJEBoQSsPszFkFnif_mW/view


## Preparing

Before going further, make sure the following commands work on your machine.

```bash
java -version
mvn -v
$GRAALVM_HOME/bin/native-image --version
curl --version
#docker version
#docker-compose version
```

```bash
# wget https://raw.githubusercontent.com/quarkusio/quarkus-workshops/refs/heads/main/quarkus-workshop-super-heroes/dist/quarkus-super-heroes-workshop-complete.zip
# unzip quarkus-super-heroes-workshop-complete.zip
# zip -q -r quarkus-super-heroes-workshop-wks23-complete.zip quarkus-super-heroes/

unzip quarkus-super-heroes-workshop-wks23.zip
```

## Backend systems in Developer Sandbox

In Developer Sandbox we have no access to Docker/Podman, so we cannot use Dev Services to start the backend automatically as containers. We need to provide them

Install Villains DB

```bash
oc new-app --name villainsdb -e POSTGRESQL_USER=superbad -e POSTGRESQL_PASSWORD=superbad -e POSTGRESQL_DATABASE=villains_database postgresql:10-el8
#oc port-forward $(oc get pod -l deployment=villainsdb -o name) 5432:5432
```

Configure db source for Villains service

```conf
# dev profile
%dev.quarkus.datasource.username=superbad
%dev.quarkus.datasource.password=superbad
%dev.quarkus.datasource.jdbc.url=jdbc:postgresql://villainsdb:5432/villains_database
%dev.quarkus.hibernate-orm.sql-load-script=import.sql

# prod profile
%prod.quarkus.datasource.username=superbad
%prod.quarkus.datasource.password=superbad
%prod.quarkus.datasource.jdbc.url=jdbc:postgresql://villainsdb:5432/villains_database
%prod.quarkus.hibernate-orm.sql-load-script=import.sql
```

Install Heroes DB

```bash
oc new-app --name heroesdb -e POSTGRESQL_USER=superman -e POSTGRESQL_PASSWORD=superman -e POSTGRESQL_DATABASE=heroes_database postgresql:10-el8
#oc port-forward $(oc get pod -l deployment=heroesdb -o name) 5432:5432
```

Configure db source for Heroes service

```conf
# dev profile
%dev.quarkus.datasource.username=superman
%dev.quarkus.datasource.password=superman
%dev.quarkus.datasource.reactive.url=postgresql://heroesdb:5432/heroes_database
%dev.quarkus.hibernate-orm.sql-load-script=import.sql

# prod profile
%prod.quarkus.datasource.username=superman
%prod.quarkus.datasource.password=superman
%prod.quarkus.datasource.reactive.url=postgresql://heroesdb:5432/heroes_database
%prod.quarkus.hibernate-orm.sql-load-script=import.sql
```

Install Fights DB

```bash
oc new-app --name fightsdb -e POSTGRESQL_USER=superfight -e POSTGRESQL_PASSWORD=superfight -e POSTGRESQL_DATABASE=fights_database postgresql:10-el8
#oc port-forward $(oc get pod -l deployment=fightsdb -o name) 5432:5432
```

Configure db source for Fights service

```conf
# dev profile
%dev.quarkus.datasource.jdbc.url=jdbc:postgresql://fightsdb:5432/fights_database
%dev.quarkus.datasource.username=superfight
%dev.quarkus.datasource.password=superfight
%dev.quarkus.hibernate-orm.sql-load-script=import.sql

# prod profile
%prod.quarkus.datasource.jdbc.url=jdbc:postgresql://fightsdb:5432/fights_database
%prod.quarkus.datasource.username=superfight
%prod.quarkus.datasource.password=superfight
%prod.quarkus.hibernate-orm.sql-load-script=import.sql
```

Install Kafka

```bash
oc apply -f infrastructure/kafka.yaml
```

Configure Kafka in Fights Service and Statistics Service

```conf
%dev.kafka.bootstrap.servers=PLAINTEXT://fights-kafka:9092
```

Delete deployments

```bash
oc delete all,cm,secret -l app=villainsdb
oc delete all,cm,secret -l app=heroesdb
oc delete all,cm,secret -l app=fightsdb
oc delete all,cm,secret -l app=fights-kafka
```

## Containers

Building containers
- https://quarkus.io/guides/container-image

```bash
mvn quarkus:add-extension -Dextensions='container-image-jib'
mvn quarkus:add-extension -Dextensions='container-image-docker'
# -Dquarkus.container-image.builder=jib
# -Dquarkus.container-image.builder=docker
mvn package -DskipTests -Dquarkus.container-image.build=true
# -Dquarkus.container-image.push=true
mvnw clean package -DskipTests -Dquarkus.container-image.build=true -Pnative -Dquarkus.native.container-build=true
```

Kubernetes/Openshift
- https://quarkus.io/guides/deploying-to-kubernetes
- https://quarkus.io/guides/deploying-to-openshift
- https://quarkus.io/guides/kubernetes-config

Add this configuration in each `application.properties` file.

```conf
quarkus.openshift.resources.limits.memory=250Mi
quarkus.openshift.resources.limits.cpu=500m
quarkus.openshift.resources.requests.cpu=10m
quarkus.openshift.resources.requests.memory=64Mi
quarkus.openshift.route.expose=true
```
Add this in `rest-fights` configuration

```conf
%prod.io.quarkus.workshop.superheroes.fight.client.HeroProxy/mp-rest/url=http://rest-heroes
%prod.io.quarkus.workshop.superheroes.fight.client.VillainProxy/mp-rest/url=http://rest-villains
%prod.quarkus.http.cors.origins=/.*/
```

Add this in `ui-super-heroes` configuration

```conf
%prod.api.base.url=<url of res-fights service>
```

Get the url of the `rest-fights` service using

```bash
oc get route rest-fights -o jsonpath={.spec.host}
```

```bash
# mvn quarkus:add-extension -Dextensions='kubernetes'
mvn quarkus:add-extension -Dextensions='openshift'
mvn quarkus:remove-extension -Dextensions='container-image-docker'
mvn clean package -DskipTests -Dquarkus.container-image.build=true
mvn clean package -DskipTests -Dquarkus.kubernetes.deploy=true
# -Dquarkus.kubernetes.deployment-target=knative # kubernetes, openshift, knative, minikube
```


## Resources

- https://quarkus.io/guides/cdi-reference
- https://quarkus.io/guides/cdi
- https://quarkus.io/guides/config-reference
- https://quarkus.io/guides/hibernate-orm-panache
- https://quarkus.io/guides/hibernate-reactive-panache
- https://quarkus.io/guides/resteasy-reactive
- https://quarkus.io/guides/rest-client-reactive
