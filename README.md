# Welcome app: React on EC2 behind an ALB (Terraform + GitHub Actions)

## One-time setup
1. **State bucket**: run the bootstrap once from your machine (Terraform >= 1.10, AWS credentials configured):
   ```
   cd bootstrap
   terraform init
   terraform apply
   ```
   Keep `bootstrap/terraform.tfstate` safe (it is gitignored).
2. **GitHub repo secrets** (Settings > Secrets and variables > Actions):
   - `AWS_ACCESS_KEY_ID`: access key of a dedicated IAM user for CI
   - `AWS_SECRET_ACCESS_KEY`: its secret key
   - `TF_STATE_BUCKET`: the `state_bucket` output from step 1

   The IAM user needs permissions for EC2, VPC, ELB, S3, SSM, and IAM roles/instance profiles
   named `welcome-app-*`.

## Workflows (`.github/workflows/`)
- `ci.yml`: on pull requests to `main`, builds the React app and runs `terraform fmt`, `validate` and `plan` (nothing is applied).
- `deploy.yml`: on push to `main`, applies Terraform, builds the site and deploys it to EC2.
- `destroy.yml`: manual run from the Actions tab; type `destroy` to tear everything down.

## Deploy
Push to `main`. The workflow runs Terraform, builds React, uploads to S3, and
syncs it onto the EC2 instance. The site URL is printed at the end of the run.

## Clean up
`cd infra && terraform init -backend-config="bucket=..." -backend-config="key=welcome-app/terraform.tfstate" -backend-config="region=eu-west-1" -backend-config="use_lockfile=true" && terraform destroy`

## Cost note
The EC2 instance is free-tier eligible, but the Application Load Balancer is only
free within the 750 hrs/month allowance of the free-tier period. Destroy when done.
