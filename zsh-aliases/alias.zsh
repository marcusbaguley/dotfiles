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
alias aws-login='$(aws ecr get-login --no-include-email --region ap-southeast-2)'
