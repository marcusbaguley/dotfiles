# Matches the current directory name against an task defintion family in ECS,
# printing out the image URL for the lastest task definition in that family.
function ecs-image-version {
  currentdirectory="${PWD##*/}"
  family=$(aws ecs list-task-definition-families | grep "$currentdirectory" | tr -d '", ')
  aws ecs describe-task-definition --task-definition "$family" | grep "image" | sed -E 's/.*"image": "(.*)".*/\1/'
}
