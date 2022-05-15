aws s3 mb s3://edjonathan-code-sam
#package cloudformation
aws cloudformation package --s3-bucket edjonathan-code-sam --template-file template.yaml --output-template-file gen/template-generated.yaml
#sam package ... atalho para aws clouformation

#deploy cloudformation
aws cloudformation deploy --template-file C:\Users\Samsung\Documents\Codigo\GIT\aws\sam\gen\template-generated.yaml --stack-name hello-world-sam --capabilities CAPABILITY_IAM
