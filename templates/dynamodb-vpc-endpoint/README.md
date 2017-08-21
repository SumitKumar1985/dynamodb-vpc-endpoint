About
====

The accompanying CloudFormation template provisions a VPC endpoint for DynamoDB. 
To demonstrate the use of the VPC endpoint, the template also provisions an EC2 instance (in a private subnet) that runs a script to put items in the table at one minute intervals. The put operations on DynamoDB use the VPC endpoint that is provisioned.
The template can be used with all of the AWS public regions (except AWS GovCloud (US) and China (Beijing) regions)

Instructions
====

- Provision a CloudFormation stack using the [template (in JSON format)](template.json) or [template (in YAML format)](template.yml)
- The parameters expected when provisioning the stack are illustrated in [parameters.json.example](parameters.json.example)
- The stack provisions the following:
  - A private subnet and route table in the specified VPC
  - VPC endpoint for DynamoDB and associated route table entry
  - A demo table in DynamoDB
  - An EC2 instance that runs a script to put items every minute into the demo table (using the VPC endpoint)
  
- One way to provision a stack is as follows:
  
```

$ # replace CHOSEN-VPC-ID in the below

$ aws --region us-east-1 cloudformation create-stack --stack-name dynamodb-vpc-endpoint-context-virginia --template-body file://template.json --parameters ParameterKey=VpcId,ParameterValue=CHOSEN-VPC-ID --capabilities CAPABILITY_IAM

```

- Deleting the stack will remove all resources provisioned

END-OF-FILE