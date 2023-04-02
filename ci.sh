#!/bin/bash

set -e

AWS_ECR_HOST="353586219743.dkr.ecr.us-east-1.amazonaws.com"
AWS_REGION="us-east-1"
AWS_IMAGE_NAME="fastapi-demo"

function ecr_login () {
  aws_version=$(aws --version)
  if [[ $aws_version == *"aws-cli/2"* ]]
  then
      aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$AWS_ECR_HOST"
  elif [[ $aws_version == *"aws-cli/1"* ]]
  then
      $(aws ecr get-login --no-include-email --region "$AWS_REGION")
  else
      kill -INT $$
  fi
}

function build_push () {
  # Create image with tag, based on current git commit
  backend_image="${AWS_ECR_HOST}/${AWS_IMAGE_NAME}:$CI_COMMIT_REF_NAME.$CI_COMMIT_SHORT_SHA"

  # Build image
  docker build -t "$backend_image" .

  # Push image to ECR
  docker push "$backend_image"
}

ecr_login
build_push
