#!/bin/bash

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 17.0.8-tem
sdk install java 22.3.3.1.r17-mandrel
sdk default java 17.0.8-tem
echo "GRAALVM_HOME=~/.sdkman/candidates/java/22.3.3.1.r17-mandrel" >> ~/.bashrc
echo "sdk default java 17.0.8-tem"  >> ~/.bashrc
source ~/.bashrc