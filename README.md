# Quarkus Workshop - Workspace


Install JDK 17

```bash
sdk default java 17.0.3-tem
echo "GRAALVM_HOME=~/.sdkman/candidates/java/22.1.0.0.r17-mandrel" >> ~/.bashrc
source ~/.bashrc
```
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
wget https://raw.githubusercontent.com/quarkusio/quarkus-workshops/refs/heads/main/quarkus-workshop-super-heroes/dist/quarkus-super-heroes-workshop-complete.zip
```