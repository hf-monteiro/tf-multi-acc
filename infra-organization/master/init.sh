#!/bin/bash
set -e -x

DEFAULT_REGION='us-east-1'

function usage {
    echo "DESCRIÇÃO:"
    echo "  Script para inicializar uma estrutura de Contas AWS"
    echo "  *** DEVE SER RODADO COM AS CREDENCIAIS DE ADMIN PARA O USUÁRIO terraform-init NA CONTA MASTER ***"
    echo ""
    echo "UTILIZAÇÃO:"
    echo "  init.sh -a terraform_init_access_key -s terraform_init_secret_key -k keybase_profile"
    echo "  [-r default_region] [-l] [-u user_name]"
    echo ""
    echo "OPÇÕES:"
    echo "  -l   pular usando o estado local, pode ser usado após o período inicial"
    echo "  -u   gerar uma senha para um usuário especificado - só funcionará se o usuário ainda não tiver uma senha"
}

function pushd () {
    command pushd "$@" > /dev/null
}

function popd () {
    command popd "$@" > /dev/null
}

while getopts "a:s:k:r:lu:h" option; do
    case ${option} in
        a ) ACCESS_KEY=$OPTARG;;
        s ) SECRET_KEY=$OPTARG;;
        k ) KEYBASE_PROFILE=$OPTARG;;
        r ) DEFAULT_REGION=$OPTARG;;
        l ) SKIP_LOCAL_STATE=1;;
        u ) LOGIN_USER=$OPTARG;;
        h )
            usage
            exit 0
            ;;
        \? )
            echo "Opção inválida: -$OPTARG" 1>&2
            usage
            exit 1
            ;;
    esac
done

if [[ -z "${ACCESS_KEY}" ]]; then
    echo "Provide the access key from AWS user terraform-init with -a key" 1>&2
    VALIDATION_ERROR=1
fi
if [[ -z "${SECRET_KEY}" ]]; then
    echo "Provide the secret key from AWS user terraform-init with -s secret" 1>&2
    VALIDATION_ERROR=1
fi
if [[ -z "${KEYBASE_PROFILE}" ]]; then
    echo "Provide the keybase profile with -k profile" 1>&2
    VALIDATION_ERROR=1
fi
if [[ -n "${VALIDATION_ERROR}" ]]; then
    usage
    exit 1
fi

export AWS_DEFAULT_REGION=${DEFAULT_REGION}

function export_master_keys {
    echo "USING MASTERS CREDENTIALS"
    export AWS_ACCESS_KEY_ID=${ACCESS_KEY}
    export AWS_SECRET_ACCESS_KEY=${SECRET_KEY}
}

function export_admin_keys {
    echo "USING ADMIN CREDENTIALS"
    export AWS_ACCESS_KEY_ID=${ADMIN_ACCESS_KEY}
    export AWS_SECRET_ACCESS_KEY=${ADMIN_SECRET_KEY}
}

pushd ./organization
export_master_keys
if [[ -n "${SKIP_LOCAL_STATE}" ]]; then
    echo "=== RUNNING REMOTE STATE CONFIGURATION OF THE ORGANIZATION ==="
    SECURITY_AWS_ACCT=$(terraform output security_acct_id)
    export "TG_AWS_ACCT=${SECURITY_AWS_ACCT}"
    terragrunt apply
    unset "TG_AWS_ACCT"
else
    echo "=== RUNNING LOCAL STATE CONFIGURATION OF THE ORGANIZATION ==="
    cp overrides/backend_local_override.tf .
    terragrunt init --terragrunt-config terragrunt-local.hcl
    terragrunt apply --terragrunt-config terragrunt-local.hcl
    SECURITY_AWS_ACCT=$(terraform output security_acct_id)
    
    echo "=== COPYING LOCAL STATE TO S3 ==="
    rm ./backend_local_override.tf || true
    sleep 10 # SLEEP APRA AS POLÍTICAS FAZEREM EFEITO
    export "TG_AWS_ACCT=${SECURITY_AWS_ACCT}"
    terragrunt init
    unset "TG_AWS_ACCT"
fi
MASTER_ALIAS=$(terraform output account_alias)
popd

echo "=== CREATING temp-admin USER ==="
pushd ./temp-admin
export "TG_AWS_ACCT=${SECURITY_AWS_ACCT}"
terragrunt apply -var security_acct_id=${SECURITY_AWS_ACCT} -var keybase=${KEYBASE_PROFILE}
unset "TG_AWS_ACCT"
ADMIN_ACCESS_KEY=$(terraform output temp_admin_access_key)
ADMIN_SECRET_KEY=$(terraform output temp_admin_secret_key | base64 --decode | keybase pgp decrypt)
popd
sleep 10

echo "=== APPLYING ACCOUNT CONFIGS ==="
export_admin_keys
pushd ../infrastructure-live/security
terragrunt init
terragrunt apply
SECURITY_ALIAS=$(terraform output account_alias)
popd
pushd ../infrastructure-live/prod
terragrunt init 
terragrunt apply
PROD_ALIAS=$(terraform output account_alias)
popd
pushd ../infrastructure-live/stage
terragrunt init
terragrunt apply
STAGE_ALIAS=$(terraform output account_alias)
popd
pushd ../infrastructure-live/dev
terragrunt init
DEV_ALIAS=$(terraform output account_alias)
popd
pushd ../infrastructure-live/shared
terragrunt init
terragrunt apply
SHARED_ALIAS=$(terraform output account_alias)
popd

if [[ -n "${LOGIN_USER}" ]]; then
    echo "=== CREATING TEMP PWD FOR ${LOGIN_USER} ==="
    pushd ../utility/one-time-login
    terragrunt apply -var user_name=${LOGIN_USER} -var security_acct_id=${SECURITY_AWS_ACCT}  -var keybase=${KEYBASE_PROFILE}
    ENCRYPTED_PASS=$(terraform output temp_password)
    terraform taint aws_iam_user_login_profile.login
    popd
fi

echo "=== INITIALIZATION COMPLETE ==="

if [[ -n "${LOGIN_USER}" ]]; then
    echo "One-time password for ${LOGIN_USER}: $(echo ${ENCRYPTED_PASS} | base64 --decode | keybase pgp decrypt)"
fi

echo "Login URL: https://${SECURITY_ALIAS}.signin.aws.amazon.com/console"
echo "Switch Role URLs -"
echo " Security Admin: https://signin.aws.amazon.com/switchrole?roleName=Administrator&account=${SECURITY_ALIAS}"
echo " Prod Admin: https://signin.aws.amazon.com/switchrole?roleName=Administrator&account=${PROD_ALIAS}"
echo " Stage Admin: https://signin.aws.amazon.com/switchrole?roleName=Administrator&account=${STAGE_ALIAS}"
echo " Dev Admin: https://signin.aws.amazon.com/switchrole?roleName=Administrator&account=${DEV_ALIAS}"
echo " Prod Developer: https://signin.aws.amazon.com/switchrole?roleName=Developer&account=${PROD_ALIAS}"
echo " Stage Developer: https://signin.aws.amazon.com/switchrole?roleName=Developer&account=${STAGE_ALIAS}"
echo " Dev Developer: https://signin.aws.amazon.com/switchrole?roleName=Developer&account=${DEV_ALIAS}"
echo " Master Billing: https://signin.aws.amazon.com/switchrole?roleName=Billing&account=${MASTER_ALIAS}"