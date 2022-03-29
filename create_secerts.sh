#!/bin/bash

create_secrets () {
    stack_name="dev-test-pp"
    name=${secret_name//_/-}
    secret_name="${stack_name}-${name}"
    arn=$(aws secretsmanager --profile stage --region us-east-1 create-secret \
        --name "$secret_name" \
        --description "$secret_description" \
        --secret-string "$json_value" | grep "arn" | cut -d ':' -f2- | tr -d ', "')

    param_name="${stack_name}-${name}-arn-ssm"
    aws ssm --profile stage --region us-east-1 put-parameter \
        --name "${param_name}" \
        --value "$arn" \
        --type String
    echo $param_name
}

secret_name="MyTestSecret8"
secret_description="My test secret created with the CLI."
json_value="{\"user\":\"diegor\",\"password\":\"EXAMPLE-PASSWORD\"}"
create_secrets $secret_name $secret_description $json_value
