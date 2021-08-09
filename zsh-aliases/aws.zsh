

function set_aws_profile () {
  unset AWS_DEFAULT_PROFILE
  [[ $PWD == "$HOME/src/loyalty"* ]] && export AWS_DEFAULT_PROFILE=loyalty
  [[ $PWD == "$HOME/src/lic-nz"* ]] && export AWS_DEFAULT_PROFILE=licnz
  [[ $PWD == "$HOME/src/kiwibank"* ]] && export AWS_DEFAULT_PROFILE=kiwibank
  [[ $PWD == "$HOME/src/abletech"* ]] && export AWS_DEFAULT_PROFILE=abletech
  export AWS_PROFILE=$ AWS_DEFAULT_PROFILE
}

function directory_presets () {
  OLD_AWS_PROFILE=$AWS_DEFAULT_PROFILE
  set_aws_profile
  if [[ $OLD_AWS_PROFILE != $AWS_DEFAULT_PROFILE ]]; then
    echo "Changing AWS profile to $AWS_DEFAULT_PROFILE"
  fi
  return $AWS_PROFILE
}

PROMPT_COMMAND='directory_presets'
RPROMPT=$(directory_presets)


# Matches the current directory name against an task defintion family in ECS,
# printing out the image URL for the lastest task definition in that family.
function ecs-image-version {
  currentdirectory="${PWD##*/}"
  family=$(aws ecs list-task-definition-families | grep "$currentdirectory" | tr -d '", ')
  aws ecs describe-task-definition --task-definition "$family" | grep "image" | sed -E 's/.*"image": "(.*)".*/\1/'
}
