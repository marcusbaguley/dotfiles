# Matches the current directory name against an task defintion family in ECS,
# printing out the image URL for the lastest task definition in that family.
function ecs-image-version {
  currentdirectory="${PWD##*/}"
  family=$(aws ecs list-task-definition-families | grep "$currentdirectory" | tr -d '", ')
  aws ecs describe-task-definition --task-definition "$family" | grep "image" | sed -E 's/.*"image": "(.*)".*/\1/'
}
# `pip install ecs-deploy`
# `asdf reshim python` # To place a shim into the shims dir of asdf you must reshim
# logs
#  aws-logs kiwibank_lint app_auth

ecs-build () {

  architecture=$(uname -m)

  case $architecture in
      x86_64|amd64)
          echo "Detected amd64 architecture."
          docker build -t ${PWD##*/} . || return 1
          ;;
      arm*|aarch64)
          echo "Detected ARM architecture."
          docker buildx build --platform linux/amd64 -t ${PWD##*/} . || return 1
          ;;
      *)
          echo "Unknown architecture: $architecture"
          return 1;
  esac

  account_id="$(aws sts get-caller-identity --query \"Account\" --output text)"
  tag="$(git describe --tags)"
  docker tag ${PWD##*/}:latest $account_id.dkr.ecr.ap-southeast-2.amazonaws.com/${PWD##*/}:$tag || return 1
  docker push $account_id.dkr.ecr.ap-southeast-2.amazonaws.com/${PWD##*/}:$tag || return
}

aws-login () {
  account_id="$(aws sts get-caller-identity --query \"Account\" --output text)"
  aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $account_id.dkr.ecr.ap-southeast-2.amazonaws.com
}

# https://github.com/fabfuel/ecs-deploy
# also, run aws-login first
ecs-deploy-kb-lint () {
  ecs-build || return 1
  parent_dir=${dir//\/bin/}
  service_name=${parent_dir##*/}

  tag="$(git describe --tags)"
  ecs deploy kiwibank-lint ${PWD##*/} -t $tag || return 1
  # ecs deploy --image $account_id.dkr.ecr.ap-southeast-2.amazonaws.com/${PWD##*/} $tag kiwibank-lint ${PWD##*/} || return 1
}

ecs-deploy-kb-uat () {
  ecs-build || return 1
  tag="$(git describe --tags)"
  ecs deploy kiwibank-uat ${PWD##*/} -t $tag || return 1
}

eks-login () {
  aws eks --region ap-southeast-2 update-kubeconfig --name rnz
}

# ecs-portal-exec staging cron
ecs-portal-exec() {
  local env="$1"
  local service="$2"

  local taskid=$(aws ecs list-tasks \
    --cluster "cluster-portal-${env}" \
    --service "${service}" | \
    jq -r '.taskArns[0]' | \
    awk -F/ '{print $NF}')

  aws ecs execute-command \
    --cli-read-timeout 0 \
    --cli-connect-timeout 0 \
    --cluster "cluster-portal-${env}" \
    --container "${service}" \
    --interactive \
    --task "${taskid}" \
    --command "sh"
}

set-portal-secret() {
  local env="$1" key="$2" value="$3"
  if [[ -z "$env" || -z "$key" || -z "$value" ]]; then
    echo "usage: set-ssm-secret <dev|staging|production> <KEY> <value>" >&2
    return 1
  fi
  case "$env" in
    dev|staging|production) ;;
    *) echo "error: environment must be dev, staging, or production" >&2; return 1 ;;
  esac

  local name="portal/${env}/${key}"
  local current
  if current=$(aws secretsmanager get-secret-value --secret-id "$name" \
                 --query SecretString --output text 2>/dev/null); then
    echo "Updating ${name} (replacing: ${current})"
    aws secretsmanager put-secret-value --secret-id "$name" --secret-string "$value" >/dev/null \
      && echo "Updated ${name}"
  else
    echo "Creating ${name}"
    aws secretsmanager create-secret --name "$name" --secret-string "$value" >/dev/null \
      && echo "Created ${name}"
  fi
}
