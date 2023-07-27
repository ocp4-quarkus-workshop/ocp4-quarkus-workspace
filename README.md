# Quarkus Workshop - Workspace


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
wget https://raw.githubusercontent.com/quarkusio/quarkus-workshops/refs/heads/main/quarkus-workshop-super-heroes/dist/quarkus-super-heroes-workshop.zip
unzip quarkus-super-heroes-workshop.zip
#wget https://raw.githubusercontent.com/quarkusio/quarkus-workshops/refs/heads/main/quarkus-workshop-super-heroes/dist/quarkus-super-heroes-workshop-complete.zip
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
%dev.quarkus.datasource.username=superbad
%dev.quarkus.datasource.password=superbad
%dev.quarkus.datasource.jdbc.url=jdbc:postgresql://villainsdb:5432/villains_database
%dev.quarkus.hibernate-orm.sql-load-script=import.sql
```

Install Heroes DB

```bash
oc new-app --name heroesdb -e POSTGRESQL_USER=superman -e POSTGRESQL_PASSWORD=superman -e POSTGRESQL_DATABASE=heroes_database postgresql:10-el8
#oc port-forward $(oc get pod -l deployment=heroesdb -o name) 5432:5432
```

Configure db source for Heroes service

```conf
%dev.quarkus.datasource.username=superman
%dev.quarkus.datasource.password=superman
%dev.quarkus.datasource.reactive.url=postgresql://heroesdb:5432/heroes_database
%dev.quarkus.hibernate-orm.sql-load-script=import.sql
```

Install Fights DB

```bash
oc new-app --name fightsdb -e POSTGRESQL_USER=superfight -e POSTGRESQL_PASSWORD=superfight -e POSTGRESQL_DATABASE=fights_database postgresql:10-el8
#oc port-forward $(oc get pod -l deployment=fightsdb -o name) 5432:5432
```

Configure db source for Fights service

```conf
%dev.quarkus.datasource.jdbc.url=jdbc:postgresql://fightsdb:5432/fights_database
%dev.quarkus.datasource.username=superfight
%dev.quarkus.datasource.password=superfight
%dev.quarkus.hibernate-orm.sql-load-script=import.sql
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