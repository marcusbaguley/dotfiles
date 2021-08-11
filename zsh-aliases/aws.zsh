

function set_aws_profile () {
  unset AWS_DEFAULT_PROFILE
  current_path=%~
  [[ $current_path == *"lic-nz"* ]] && export AWS_DEFAULT_PROFILE=licnz
  [[ $current_path == *"kiwibank"* ]] && export AWS_DEFAULT_PROFILE=kiwibank
  [[ $current_path == *"abletech"* ]] && export AWS_DEFAULT_PROFILE=abletech
  [[ $current_path == *"src/abletech"* ]] && echo 'in abletech'
  echo $AWS_DEFAULT_PROFILE
  export AWS_PROFILE=$AWS_DEFAULT_PROFILE
}

function directory_presets () {
  OLD_AWS_PROFILE=$AWS_DEFAULT_PROFILE
  set_aws_profile
  if [[ $OLD_AWS_PROFILE != $AWS_DEFAULT_PROFILE ]]; then
    echo "Changing AWS profile to $AWS_DEFAULT_PROFILE"
  fi
  echo "AWS profile to $AWS_DEFAULT_PROFILE"
  return ''
}

#setopt PROMPT_SUBST
#PROMPT="$(directory_presets)$PROMPT"


# Matches the current directory name against an task defintion family in ECS,
# printing out the image URL for the lastest task definition in that family.
function ecs-image-version {
  currentdirectory="${PWD##*/}"
  family=$(aws ecs list-task-definition-families | grep "$currentdirectory" | tr -d '", ')
  aws ecs describe-task-definition --task-definition "$family" | grep "image" | sed -E 's/.*"image": "(.*)".*/\1/'
}
