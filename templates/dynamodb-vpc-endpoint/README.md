About
====

The accompanying CloudFormation template provisions a VPC endpoint for DynamoDB. To demonstrate the use of the VPC endpoint, the template also provisions an EC2 instance that runs a script to puts items in the table at one minute intervals. The put operations on DynamoDB use the VPC endpoint that is provisioned.

Instructions
====

- Provision a CloudFormation template using [template.json](template.json)
- The parameters expected when provisioning the stack are illustrated in [parameters.json.example](parameters.json.example)
- The stack provisions the following:
  - A private subnet and route table in the specified VPC
  - VPC endpoint for DynamoDB and associated route table entry
  - A demo table in DynamoDB
  - An EC2 instance that runs a script to put items every minute into the demo table (using the VPC endpoint)
  
Current limitations
====

(these are being addressed as TODOs)

- The template currently caters to the following regions: "us-east-1", "ap-south-1"
