#!/bin/bash

# Script de Deploy - Infraestrutura Terraform
# Uso: ./deploy.sh [options]
# Options:
#   --all              Deploy de todos os módulos (padrão)
#   --network          Deploy apenas do módulo network
#   --security         Deploy apenas do módulo security
#   --repository       Deploy apenas do módulo repository
#   --compute          Deploy apenas do módulo compute
#   --storage          Deploy apenas do módulo storage
#   --cdn              Deploy apenas do módulo cdn
#   --auto-approve     Aplica terraform sem confirmação manual
#   --help             Mostra esta mensagem

set -e  # Para execução em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variáveis
AUTO_APPROVE=""
DEPLOY_ALL=true
DEPLOY_NETWORK=false
DEPLOY_SECURITY=false
DEPLOY_REPOSITORY=false
DEPLOY_COMPUTE=false
DEPLOY_STORAGE=false
DEPLOY_CDN=false


AWS_REGION_PRIMARY="xxxxxxx"
AWS_REGION_SECONDARY="xxxxxxx"
AWS_ACCOUNT_ID="xxxxxxx"
DOCKER_IMAGE_NAME="xxxxxxx:latest" 
ECR_REPO_NAME="xxxxxxx"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


show_help() {
    cat << EOF
Uso: $0 [options]

Options:
  --all              Deploy de todos os módulos (padrão)
  --network          Deploy apenas do módulo network
  --security         Deploy apenas do módulo security
  --repository       Deploy apenas do módulo repository
  --compute          Deploy apenas do módulo compute
  --storage          Deploy apenas do módulo storage
  --cdn              Deploy apenas do módulo cdn
  --auto-approve     Aplica terraform sem confirmação manual
  --help             Mostra esta mensagem

Exemplos:
  $0 --all --auto-approve
  $0 --network --security
  $0 --compute
EOF
    exit 0
}

# Parse dos argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            DEPLOY_ALL=true
            shift
            ;;
        --network)
            DEPLOY_ALL=false
            DEPLOY_NETWORK=true
            shift
            ;;
        --security)
            DEPLOY_ALL=false
            DEPLOY_SECURITY=true
            shift
            ;;
        --repository)
            DEPLOY_ALL=false
            DEPLOY_REPOSITORY=true
            shift
            ;;
        --compute)
            DEPLOY_ALL=false
            DEPLOY_COMPUTE=true
            shift
            ;;
        --storage)
            DEPLOY_ALL=false
            DEPLOY_STORAGE=true
            shift
            ;;
        --cdn)
            DEPLOY_ALL=false
            DEPLOY_CDN=true
            shift
            ;;
        --auto-approve)
            AUTO_APPROVE="-auto-approve"
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            log_error "Opção desconhecida: $1"
            show_help
            ;;
    esac
done


terraform_module() {
    local module_name=$1
    log_info "Iniciando deploy do módulo: $module_name"
    
    cd "$module_name"
    echo "pwd: $(pwd)"
    
    terraform refresh
    terraform apply $AUTO_APPROVE
    
    cd ..
    log_info "Deploy do módulo $module_name concluído!"
}


check_docker_image() {
    log_info "Verificando se a imagem $DOCKER_IMAGE_NAME existe..."
    
    if ! docker image inspect $DOCKER_IMAGE_NAME &> /dev/null; then
        log_error "Imagem $DOCKER_IMAGE_NAME não encontrada!"
        log_warn "Execute: docker build -t projeto:latest ."
        exit 1
    fi
    
    log_info "Imagem encontrada!"
}

ecr_login() {
    log_info "Fazendo login no ECR..."
    
    aws ecr get-login-password --region $AWS_REGION_PRIMARY | \
        docker login --username AWS --password-stdin \
        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION_PRIMARY}.amazonaws.com 2>/dev/null
    
    aws ecr get-login-password --region $AWS_REGION_SECONDARY | \
        docker login --username AWS --password-stdin \
        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION_SECONDARY}.amazonaws.com 2>/dev/null
    
    log_info "Login no ECR concluído!"
}


docker_push() {
    log_info "Fazendo tag e push das imagens Docker..."
    

    check_docker_image

    log_info "Criando tag para ${AWS_REGION_PRIMARY}..."
    docker tag $DOCKER_IMAGE_NAME \
        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION_PRIMARY}.amazonaws.com/${ECR_REPO_NAME}:projeto
    

    log_info "Criando tag para ${AWS_REGION_SECONDARY}..."
    docker tag $DOCKER_IMAGE_NAME \
        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION_SECONDARY}.amazonaws.com/${ECR_REPO_NAME}:projeto
    

    log_info "Enviando imagem para ${AWS_REGION_PRIMARY}..."
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION_PRIMARY}.amazonaws.com/${ECR_REPO_NAME}:projeto
    

    log_info "Enviando imagem para ${AWS_REGION_SECONDARY}..."
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION_SECONDARY}.amazonaws.com/${ECR_REPO_NAME}:projeto
    
    log_info "Push das imagens concluído!"
}


s3_upload() {
    log_info "Fazendo upload dos arquivos frontend para S3..."
    
    aws s3 cp /frontend/src/index.html s3://frontend_primary/index.html
    aws s3 cp /frontend/src/index.html s3://frontend_secondary/index.html
    
    log_info "Upload para S3 concluído!"
}

# ========== INÍCIO DO DEPLOY ==========

log_info "Iniciando processo de deploy..."

cd terraform

# Network
if [[ "$DEPLOY_ALL" == true || "$DEPLOY_NETWORK" == true ]]; then
    terraform_module "network"
fi

# Security
if [[ "$DEPLOY_ALL" == true || "$DEPLOY_SECURITY" == true ]]; then
    terraform_module "security"
fi

# Repository
if [[ "$DEPLOY_ALL" == true || "$DEPLOY_REPOSITORY" == true ]]; then
    terraform_module "repository"
    ecr_login
    docker_push
fi

# Compute
if [[ "$DEPLOY_ALL" == true || "$DEPLOY_COMPUTE" == true ]]; then
    terraform_module "compute"
fi

# Storage
if [[ "$DEPLOY_ALL" == true || "$DEPLOY_STORAGE" == true ]]; then
    terraform_module "storage"
fi

# CDN
if [[ "$DEPLOY_ALL" == true || "$DEPLOY_CDN" == true ]]; then
    terraform_module "cdn"
    s3_upload
fi

log_info "Deploy concluído com sucesso! 🚀"