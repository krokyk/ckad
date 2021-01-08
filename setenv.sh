#!/bin/bash
source ~/.bashrc

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )
export K8S_DIR=$(realpath "$THIS_DIR")
export CKAD_RSA_KEY="/e/Google Drive/credentials, auth, recovery/ckad/ckad.rsa"
chmod 600 "$CKAD_RSA_KEY"

TOOLS_DIR="$K8S_DIR/tools"
echo "TOOLS_DIR=$TOOLS_DIR"

echo "OSTYPE is $OSTYPE"

OS='unknownOS'
if [[ "$OSTYPE" == 'msys' ]]; then
    OS='windows'
elif [[ "$OSTYPE" == 'linux-gnu' ]]; then
    OS='linux'
fi

export EDITOR='nano'

#VERSIONS
KUBECTL_VERSION="1.20.1"
KUBECTX_VERSION="0.9.1"

export PATH=$TOOLS_DIR\
:$TOOLS_DIR/kubectl/$KUBECTL_VERSION\
:$TOOLS_DIR/kubectx/$KUBECTX_VERSION\
:$PATH

#some terminal text colors to use in the scripts
R=$(tput setaf 1) #red text color
G=$(tput setaf 2) #green text color
Y=$(tput setaf 3) #yellow text color
B=$(tput setaf 4) #blue text color
M=$(tput setaf 5) #magenta text color
C=$(tput setaf 6) #cyan text color
W=$(tput setaf 7) #white text color
N=$(tput sgr0) #normal text color

alias k=kubectl
alias kns=kubens
alias watch='watch ' # https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
alias env='env | sort'

# bash completion for kubectl
source <(kubectl completion bash)
# enable bash completion when using alias
complete -F __start_kubectl k

echo ""
echo "${Y}Useful commands${N}"

get-deployed-versions() {
    kubectl get pod -o json | jq .items[].spec.containers[].image
}
echo "get-deployed-versions"

export KUBE_PS1_SYMBOL_ENABLE=false # does not work in ConEmu
source $TOOLS_DIR/kube-utils/kube-ps1.sh
PS1='[\w $(kube_ps1)]\$ '
