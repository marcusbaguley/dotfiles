# update a image_tag in a named environment
image-tag () {
  environment=$1
  tag=$(git describe --tags);
  NEW_VERSION=${tag//\//-}
  file="./infrastructure/$1/main.tf"
  if [[ -e $file ]]; then
      file="infrastructure/$1/main.tf"
      sed -i '' '/image_tag/s/".*"/"'$NEW_VERSION'"/' $file
  else
    echo "usage image_tag <environment> "
    echo "Could not find file: $file"
  fi
}
alias groot='cd $(git rev-parse --show-toplevel)'
aws-login () {
  if [[ $1 == 'kiwibank' ]]; then
    aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 558833745501.dkr.ecr.ap-southeast-2.amazonaws.com
  else
    echo 'please pass profile name or configure script'
  fi
}
