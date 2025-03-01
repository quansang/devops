# DevOps

## How to do

### Install

- **aws-cli**: is a package provides a unified command line interface to Amazon Web Services.

Refer how to install [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) base on your OS.

- **terraform**: is a tool for building, changing, and versioning infrastructure safely and efficiently.

Refer how to install [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) base on your OS.

### Config

- Create AWS profile

  ```bash
    aws configure --profile {{ project }}-{{ env }}
        AWS Access Key ID: <your-access-key>
        AWS Secret Access Key: <your-secret-access-key>
        Default region name: {{ region }}
        Default output format: json
  ```

- Check ~/.aws/credentials

  ```bash
  [{{ project }}-{{ env }}]
  aws_access_key_id =
  aws_secret_access_key =
  ```

- Set ~/.aws/config

  ```bash
  [profile {{ project }}-{{ env }}]
  output = json
  region = {{ region }}
  ```

- Create manually [AWS S3 bucket](https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html)

  ```bash
  aws s3api create-bucket --bucket {{ project }}-{{ env }}-iac-state --region {{ region }} --create-bucket-configuration LocationConstraint={{ region }} --profile {{ project }}-{{ env }}
  aws s3api put-bucket-versioning --bucket {{ project }}-{{ env }}-iac-state --versioning-configuration Status=Enabled --region {{ region }} --profile {{ project }}-{{ env }}
  aws s3api put-public-access-block \
      --bucket {{ project }}-{{ env }}-iac-state \
      --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" \
      --region {{ region }} --profile {{ project }}-{{ env }}
  ```

### Structure

```bash
terraform/
├── envs/
│   ├── dev/
│   └── prd/
└── modules/ # Terraform modules for all AWS services
dependencies/
├── templates/
├── scripts/
└── tests/
```

### Diagram

![Diagram](./images/diagram.png)

- AWS Route53: Manage DNS Domain.
- AWS InternetGateway: Allow traffic from Internet in/out VPC.
- AWS NAT Gateway: All ECSs that into Private Subnet could access to Internet.
- AWS ALB(Load Balancer) - External: Automatically distributes incoming traffic across multiple targets from Internet.
- AWS ECS: At private subnet, running application on container in cluster.
- AWS ECR: Managed container image registry service to push, pull and manage images.
- AWS VPC: Appropriate firewall rules assigned via security groups and ACL enforce only certain traffic to pass thru to the subnet.

### CI/CD Pipeline

![CICD](./images/devops-test.png)
All files in `devops-test/ops` are used for CI/CD pipeline.

- CodePipeline: collaborating with AWS Codestar to connect to GitHub repository and trigger pipeline when push to repository in branch `main` of `devops-test`.
- Codebuild:
  - Build image to ECR
  - Run Unit Testing: run pytest with built image by using docker container
  - Push image to ECR
  - Prepare artifact for CodePipeline
- CodeDeploy:
  - Get artifact from CodeBuild include image detail and task definition of application
  - Deploy to ECS Fargate(Blue/Green Strategy)

### Results

#### Pipeline

![Codepipeline](./images/codepipeline.png)

#### Blue-green Deployment

![Blue-green Deployment](./images/bluegreen-deployment.png)

#### Application

![Root-route](./images/root-route.png)

![Healthcheck-route](./images/healthcheck-route.png)
