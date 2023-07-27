#!/bin/bash

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk default java 17.0.3-tem
sdk install java 22.3.2.1.r17-mandrel
echo "GRAALVM_HOME=~/.sdkman/candidates/java/22.3.2.1.r17-mandrel" >> ~/.bashrc
echo "sdk default java 17.0.3-tem"  >> ~/.bashrc
source ~/.bashrc