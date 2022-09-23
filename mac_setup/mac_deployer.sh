#!/usr/bin/env bash
set -e
export $(grep -v '^#' .env | xargs -0)

: <<'DOC'
Run this script in your project code directory where you'd keep work items.
Note: This script clones `neuron` and `nucleus` repositories, therefore DO NOT run this
from inside "scripts" folder of neuron repository.

Sample Usage (Create .env from .env.sample in folder and add credentials from 1Password > Engineering vault):
bash mac_deployer.sh 

Optional flags:
    --skip_build_images true    # if you don't want to build both neuron and nucleus images
DOC

cat << "EOF"
=====================================================
=====================================================
=====  .___________.    ___           _______.  =====
=====  |           |   /   \         /       |  =====
=====  `---|  |----`  /  ^  \       |   (----`  =====
=====      |  |      /  /_\  \       \   \      =====
=====      |  |     /  _____  \  .----)   |     =====
=====      |__|    /__/     \__\ |_______/      =====
=====================================================
=====================================================
EOF

#
#Set Colors
#

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

#
# Headers and  Logging
#

e_header() { printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@" 
}
e_arrow() { printf "➜ $@\n"
}
e_success() { printf "${green}✔ %s${reset}\n" "$@"
}
e_error() { printf "${red}✖ %s${reset}\n" "$@"
}
e_warning() { printf "${tan}➜ %s${reset}\n" "$@"
}
e_underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
e_bold() { printf "${bold}%s${reset}\n" "$@"
}
e_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}
e_line_break() { printf "\n" 
}

########################
# Constants declation
########################

# Softwares to install
PREREQUISITE_SOFTWARES=("minikube" "kubectl" "hyperkit" "helm" "vault" "jq")
# Repositories you want to clone and their respective folders
REPO_TO_CLONE=(
    "neuron" "git@github.com:LambdaTest/neuron.git"
    "test-at-scale" "git@github.com:LambdaTest/test-at-scale.git"
    "photon" "git@github.com:LambdaTest/photon.git"
    "laser" "git@github.com:LambdaTest/laser.git"
)
# configuration details
# directory, filename
GENERATE_CONFIG=(
    "neuron" ".nu.json"
    "photon" ".ph.json"
    "laser" "environments/.env.local"
)
# migration details
# database, migration-path
DB_MIGRATIONS=(
    "photon" "neuron/migrations/"
)
# Database to be created
CREATE_DB=("photon")

# Auto populating variables
CWD=$(pwd)

########################
# Basic script setup
########################
# Reading passed named parameters
skip_build_images=${skip_build_images:-false}
private_ip=$(ipconfig getifaddr en0)
local_ip="127.0.0.1"

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # printf $1 $2 // Optional to see the parameter:value result
   fi

  shift
done


########################
# Declaring function
########################

# Preflight checks
function preflight_checks() {
    e_header "Performing preflight checks"
    if ! command -v $software &> /dev/null; then
        e_error "Docker is not installed. Please install docker desktop."
        e_error "https://www.docker.com/products/docker-desktop"
    else
        e_success "Docker is installed"
    fi
    if (! docker stats --no-stream &> /dev/null ); then
        # On Mac OS this would be the terminal command to launch Docker
        e_warning "Docker is not running. Starting docker..."
        open /Applications/Docker.app
        #Wait until Docker daemon is running and has completed initialisation
        e_warning "Waiting for Docker to launch..."
        while (! docker stats --no-stream &> /dev/null ); do
            # Docker takes a few seconds to initialize
            printf "."
            sleep 1
        done
        e_line_break
    else
        e_success "Docker is up and running"
    fi
    e_success "Done"
}

# installing prerequisite softwares
function install_prerequisite() {
    e_header "Installing Pre Requisite Softwares"
    if ! command -v "brew" &> /dev/null
    then
        e_error "Please install brew to continue. You can find instruction here ➜ https://brew.sh/"
        e_error "Or you can use the command below"
        e_error "/bin/bash -c '\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"
        exit
    fi
    NOT_INSTALLED=()
    for software in ${PREREQUISITE_SOFTWARES[@]}
    do
        if ! command -v $software &> /dev/null
        then
            NOT_INSTALLED+=($software)
            e_error "$software not found."
        fi
    done
    if [ ${#NOT_INSTALLED[@]} -gt "0" ];then
        e_arrow "List of softwares are going to be installed: ${NOT_INSTALLED[@]}"
    else
        e_success "Prerequisite are satisfied."
    fi
    for sotfware in ${NOT_INSTALLED[@]}
    do
        e_arrow "Installing ${software}"
        brew install ${software}
    done
    e_success "Done"
}


# Setup golang and required configuration
function setup_golang() {
    e_header "Setting up golang"
    if ! command -v "go" &> /dev/null
    then
        e_arrow "Installing golang"
        brew install golang
    fi

    e_arrow "Setting up the bash profile..."
cat >~/.zshrc <<EOL
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
EOL
    source ~/.zshrc

    if ! command -v "migrate" &> /dev/null
    then
        e_arrow "Installing go-migrate.."
        brew install golang-migrate
    fi
    e_success "Done"
    
}

function clone_repo() {
    e_header "Cloning repositories"
    for (( i=0; i<${#REPO_TO_CLONE[*]}; i+=2 ));
    do
        cd ${CWD}
        if [ ! -d "${REPO_TO_CLONE[$i]}" ]; then
            e_arrow "Cloning ➜ ${REPO_TO_CLONE[$i+1]}"
            git clone ${REPO_TO_CLONE[$i+1]} && cd ${REPO_TO_CLONE[$i]} && git checkout stage \
            || (e_error "Error cloning ${REPO_TO_CLONE[$i+1]}" && exit)
        else
            e_arrow "${REPO_TO_CLONE[$i+1]}: already exsists."
        fi
    done
    e_success "Done"
}

function setup_common_components() {
    e_header "Setting up common components"
    e_arrow "Components: Redis, MySQL"
    DB_PASS=${db_pass} docker-compose up -d
    sleep 20
    e_arrow "creating databases"
    create_databases
}

function setup_kafka() {
    e_header "Setting up Kafka"
    cd strimzi-kafka
    bash ./cleanup.sh
    bash ./setup.sh
    cd ${CWD}
    e_success "Done"
}

function create_databases() {
    e_header "Creating database"
    for db in ${CREATE_DB[@]};
    do
        e_arrow "Creating database: ${db}"
        docker exec mysql /bin/sh -c "echo \"create database ${db}\" | mysql -uroot -p${db_pass}" \
            && e_success "Database ${db} created successfully." \
            || e_error "Error creating ${db}."
    done
}

function run_migrations() {
    e_header "Running migrations"
    for (( i=0; i<${#DB_MIGRATIONS[*]}; i+=2 ));
    do
        cd ${CWD}
        e_warning "Running Migrating from: ${DB_MIGRATIONS[$i+1]} into database: ${DB_MIGRATIONS[$i]}"
        migrate \
            -path ${DB_MIGRATIONS[$i+1]} \
            -database "mysql://root:${db_pass}@tcp(localhost:3306)/${DB_MIGRATIONS[$i]}" \
            -verbose up \
            && e_success "Migration ${DB_MIGRATIONS[$i+1]} completed successfully." \
            || e_error "Failed to apply migration ${DB_MIGRATIONS[$i+1]}."
    done
}

function kill_container() {
    # if [ "$( docker container inspect -f '{{.State.Running}}' "$1" )" == "true" ]; then
    if [ "$(docker ps -aq -f name=$1)" ]; then
        e_arrow "Killing $1 container..."
        (docker rm -f $(docker ps -aq -f name=$1) &> /dev/null && e_success "Container $1 killed successfully") || e_error "Error killing container $1"
    else
        e_arrow "Container $1 is not running"
    fi
}

function wait_for_container() {
    e_warning "Waiting for $1 to start..."
    while [ "$( docker container inspect -f '{{.State.Running}}' $1 )" != "true" ]; do
        printf "."
        sleep 1;
	done
    e_success "Container $1 started successfully."
}

function k8s_startup() {
    e_header "Starting up minikube"
    minikube start --driver=hyperkit --cpus 4 --memory 8192 --disk-size=50g
    minikube addons enable ingress
    minikube addons enable metrics-server
    # Merge docker env of minikube before building neuron and nucleus docker images
    e_arrow "Merging docker env of host with minikube vm"
    eval $(minikube docker-env)
    e_success "Done"
}

function generate_config_json() {
    e_header "Geneating config files"
    e_arrow "Generating private/public keys..."
    openssl genrsa  -out private.pem 2048
    openssl rsa -in private.pem -outform PEM -pubout -out public.pem
    private_key=$(cat private.pem | base64)
    public_key=$(cat public.pem | base64)

    for (( i=0; i<${#GENERATE_CONFIG[*]}; i+=2 ));
    do
        e_arrow "Creating ${GENERATE_CONFIG[$i+1]} for ${GENERATE_CONFIG[$i]}"
        cd ${GENERATE_CONFIG[$i]}
        rm -f ${GENERATE_CONFIG[$i+1]} || e_arrow "No existing configuration found: ${GENERATE_CONFIG[$i+1]}"
    if [ "${GENERATE_CONFIG[$i]}" == "neuron" ]; then
    cat >${GENERATE_CONFIG[$i+1]} <<EOL
{
  "azure": {
    "payloadContainerName": "container-payload",
    "cacheContainerName": "cache",
    "coverageContainerName": "coverage",
    "storageAccessKey": "${azure_acc_key}",
    "storageAccountName": "${azure_acc_name}",
    "metricsContainerName": "metrics",
    "logsContainerName":"logs",
    "cdnURL": "https://tas.azureedge.net"

  },
  "webhookAddress": "http://local-webhooks.lambdatest.io",
  "frontendURL": "https://dev.lambdatest.io:3000",
  "db": {
    "host": "local-db.lambdatest.io",
    "name": "photon",
    "password": "${db_pass}",
    "port": 3306,
    "user": "root"
  },
  "env": "dev",
  "enableTracing": false,
  "logConfig": {
    "format": "json"
  },
  "gitHubApp": {
    "appName": "${github_app_app_name}",
    "appID": "${github_app_app_id}",
    "clientID": "${github_app_client_id}",
    "clientSecret": "${github_app_client_secret}",
    "privateKey": "${github_app_private_key}",
    "scope": "repo,repo:status,user:email,read:org",
    "server": "https://github.com"
  },
  "gitLab": {
    "clientID":"${gitlab_client_id}",
    "clientSecret": "${gitlab_client_secret}",
    "redirectURL": "http://tas-local.lambdatest.io/login/gitlab",
    "privateRepoScope": "api,read_user,read_api,email,read_repository",
    "server": "https://gitlab.com",
    "refreshTokenEndpoint": "https://gitlab.com/oauth/token"
  },
  "bitbucket": {
    "clientID":"${bitbucket_client_id}",
    "clientSecret": "${bitbucket_client_secret}",
    "redirectURL": "http://tas-local.lambdatest.io/login/bitbucket",
    "refreshTokenEndpoint": "https://bitbucket.org/site/oauth2/access_token"
  },
  "jwt": {
    "privateKey": "${private_key}",
    "publicKey": "${public_key}",
    "timeout": 2592000000000000
  },
  "port": 9876,
  "vault": {
    "address": "http://local-vault.lambdatest.io:8200"
  },
  "redis": {
    "addr" :"local-redis.lambdatest.io:6379"
  },
 "kafka": {
    "brokers": "my-cluster-kafka-bootstrap.kafka:9092",
    "build_abort_queue": {
        "topic": "build-abort",
        "consumer_group": "neuron-build-abort"
    },
    "webhook": {
      "topic": "photon-neuron-webhook",
      "consumer_group": "neuron-webhook"
    },
    "task_queue": {
      "topic": "task-queue",
      "consumer_group": "neuron-task-queue"
    },
    "post_processing_queue": {
      "topic": "post-processing-queue",
      "consumer_group": "neuron-post-processing-queue"
    }
  }
}
EOL
    elif [ "${GENERATE_CONFIG[$i]}" == "photon" ]; then
     cat >${GENERATE_CONFIG[$i+1]} <<EOL
{
  "db": {
    "host": "local-db.lambdatest.io",
    "name": "${GENERATE_CONFIG[$i]}",
    "password": "${db_pass}",
    "port": 3306,
    "user": "root"
  },
  "env": "dev",
  "logConfig": {
    "format": "json"
  },
  "port": 9876,
  "redis": {
    "addr" :"local-redis.lambdatest.io:6379"
  },
  "kafka": {
    "brokers": "my-cluster-kafka-bootstrap.kafka:9092",
    "topic": "photon-neuron-webhook"
  }
}
EOL
    elif [ "${GENERATE_CONFIG[i]}" == "laser" ]; then
        cat > ${GENERATE_CONFIG[i+1]} <<EOL
NEXT_PUBLIC_API_BASE_URL = https://tas-local.lambdatest.io
NEXT_PUBLIC_AUTH_COOKIE = _dev_session_
NEXT_PUBLIC_AMPLITUDE_KEY = 4a086d81e406efbf620b13181a18ab22
NEXT_PUBLIC_WEBSITE_HOST = https://staging.lambdatest.com
NEXT_PUBLIC_DOC_HOST = https://staging.lambdatest.com/support/docs
NEXT_PUBLIC_APPLICATION_ID=fea78924303a4b59f222
NEXT_PUBLIC_TAS_ASSETS=https://dev.lambdatest.io:3000/assets
NEXT_PUBLIC_GTM_ID=GTM-5CZ66DJ
NEXT_PUBLIC_GITHUB_APP_NAME=utkarsh-tas
EOL
    fi
    
    cd $CWD
    done
    e_success "Done"
}

function build_docker_images() {
    e_header "Building docker images"
    # replace this with compose build
    e_arrow "Building photon docker image..."
    cd photon
    docker build --tag=photon --rm . \
    && e_success "Photon docker image built successfully." \
    || e_error "Error building Photon."
    cd $CWD
	# rm -rf photon

    # replace this with compose build
    e_arrow "Building neuron docker image"
    cd $CWD
    cd neuron
	bash build.sh
	docker build --tag=neuron --rm . \
        && e_success "Neuron docker image built successfully." \
        || e_error "Error building Neuron."
	rm -rf neuron

    e_arrow "Building Seccomploader docker image"
    cd seccomp
    docker build --tag=seccomploader --rm . \
        && e_success "Seccomploader docker image built successfully." \
        || e_error "Error building Seccomploader."

    # replace this with compose build
    e_arrow "Building nucleus docker image"
    cd $CWD
    cd test-at-scale
	make build-nucleus-image \
        && e_success "Nucleus docker image built successfully." \
        || e_error "Error building Nucleus."

    cd $CWD

    e_success "Done"
}

function setup_vault() {
    # Setup vault
    e_header "Setting up Local Vault"
    cd $CWD
    cd neuron/deployment/minikube/vault
    bash ./cleanup.sh
    bash ./vault-init.sh --tls --helm
    cd $CWD
    cd photon/deployment/minikube/vault
    bash ./vault-init.sh
    cd $CWD
    e_success "Done"
}

function deploy_on_k8s() {
    e_header "Setting up kubernetes"
    cd $CWD
    cd neuron/deployment/minikube
    if [ "$(kubectl get namespace | grep -c phoenix)" != "0" ]; then
        e_warning "Deleting namespace phoenix"
        kubectl delete namespace phoenix --wait
    fi
    e_arrow "Creating phoenix"
    kubectl create namespace phoenix
    e_arrow "Setting default config"
    kubectl config set-context --current --namespace=phoenix
    e_arrow "Applying neruon kubernetes files."
    kubectl apply -f .
    cd $CWD
    cd photon/deployment/minikube
    e_arrow "Applying photon kubernetes files."
    kubectl apply -f .
    cd $CWD
    e_success "Done"
}

function extra_info() {
    e_header "Help"
    e_arrow "Deployed application in Minikube environment."
    e_line_break
    e_note "To see the running pods Use the command below."
    e_arrow "kubectl get pods"
    e_line_break
    e_warning "TaS will be accessible by 'tas-local.lambdatest.io'"
    e_line_break
}

function deploy_frontend() {
    cd $CWD
    lsof -i -P | grep LISTEN | grep :3000 | awk '{print $2}' | xargs kill -9
    sed -i  '' 's/dev.lambdatest.com/dev.lambdatest.io/g' laser/server.js && echo "updated hostname"
    sed -i  '' 's/.lambdatest.com/.lambdatest.io/g' laser/helpers/genericHelpers.js && echo "updated hostname"
    cd laser
    mkcert -install
    mkcert dev.lambdatest.io
    npm ci
    nohup npm run dev:local & >/dev/null 2>&1
    cd $CWD
}

function update_hosts() {
    e_header "Updating /etc/hosts entries"
    minikube_ip_address="$(minikube ip)"
    ips=($minikube_ip_address $private_ip $local_ip)
    minikube_hosts="tas-local.lambdatest.io local-webhooks.lambdatest.io dashboard-local.lambdatest.io"
    local_hosts="local-vault.lambdatest.io local-db.lambdatest.io local-redis.lambdatest.io"
    private_local_ip="dev.lambdatest.io"
    hostnames=("$minikube_hosts" "$local_hosts", "$private_local_ip")

    e_header "Updating kubernetes coredns"
    kubectl get cm -n kube-system coredns -oyaml | sed -e 's|host.minikube.internal|host.minikube.internal dev.lambdatest.com local-vault.lambdatest.io local-db.lambdatest.io local-redis.lambdatest.io|' | kubectl replace -f -

   for ((i = 0; i < ${#hostnames[@]}; i++))
    do
        matches_in_hosts="$(grep -n -e "${hostnames[$i]}" /etc/hosts | cut -f1 -d:)"
        host_entry="${ips[$i]} ${hostnames[$i]}"
        e_arrow "Please enter your password if requested:"

        if [ ! -z "$matches_in_hosts" ]
        then
            e_arrow "Updating existing hosts entry."
            # replace the text of each line with the desired host entry
            sudo sed -i '' "s/.*${hostnames[$i]}/${host_entry}/g" /etc/hosts
            e_success "/etc/hosts updated."
        else
            e_arrow "Adding new hosts entry."
            echo "${host_entry}" | sudo tee -a /etc/hosts > /dev/null
        fi
        e_success "Done"
    done
}

function restart_deployment() {
    e_header "Restarting deployments"
    kubectl rollout restart deployment/neuron
    kubectl rollout restart deployment/photon
    e_success "Done"
}

########################
# Script execution starts here
########################
preflight_checks
install_prerequisite
setup_golang
clone_repo
setup_common_components
run_migrations
k8s_startup
setup_kafka
generate_config_json
if [ $skip_build_images == "false" ]; then
    build_docker_images
else
    e_note "Skipping docker image build."
fi
setup_vault
deploy_on_k8s
deploy_frontend
update_hosts
restart_deployment
extra_info
e_success "Application deployed successfully."
