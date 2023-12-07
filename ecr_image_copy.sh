#!/bin/bash
export AWS_PROFILE=default

aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 474975247937.dkr.ecr.eu-central-1.amazonaws.com

docker pull 474975247937.dkr.ecr.eu-central-1.amazonaws.com/forseti-acceptance-test:latest

docker tag 474975247937.dkr.ecr.eu-central-1.amazonaws.com/forseti-acceptance-test:latest 463162183542.dkr.ecr.eu-central-1.amazonaws.com/forseti-acceptance-test:latest

export AWS_PROFILE=shared

aws ecr get-login-password --region eu-central-1| docker login --username AWS --password-stdin 463162183542.dkr.ecr.eu-central-1.amazonaws.com

docker push 463162183542.dkr.ecr.eu-central-1.amazonaws.com/forseti-acceptance-test:latest



# MANIFEST=$(aws ecr batch-get-image --repository-name aws-for-fluent-bit --region eu-central-1 --image-ids imageDigest=sha256:a351d5e3d53d07c96bf3d6054453a606fdcca550c68f015ff345a78d41eee4a9 --query 'images[].imageManifest' --output text)
# aws ecr put-image --repository-name aws-for-fluent-bit --region eu-central-1 --image-tag test --image-manifest "$MANIFEST"
