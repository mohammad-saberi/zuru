# Assessment Phase 1

For testing the app in a local environment, please head over to the local branch and follow the related readme file.

git clone -b local https://gitlab.com/your-repo/go-microservice.git

# Assessment Phase 2


For This phase, Instead of nginx because of the AWS ALB power and it's integration capabilities, I used ALB.

The logs of ALB will be sent to Cloud Watch and also be kept in a s3 bucket.

Both of them have cycle policy. The app only accept traffics from ALB's Security Group.

Tried to follow best practices and enhancing security improvemnets.

The all terraform configurations files are located in terraform folder.

Instead of putting all files together, for ease of use, each component is in a separate file.

Tried to use envs instead of hardcoding.

Also tried to use AWS LocalStack for simulation.

After Cloning:

cd terraform

""update the environment related file

terraform init

terraform validate

terraform plan -var-file terraform-development.tfvars # For Development Environment

terraform plan -var-file terraform-production.tfvars # For Production Environment

terraform apply -var-file terraform-development.tfvars # For Development Environment

terraform apply -var-file terraform-production.tfvars # For Production Environment

# Assessment Phase 3

Added a multi-stage CI/CD file.

For this phase assumed that the CI/CD must covers both app and infrastructure deployments.

These variables need to be defined in GitLab Variable for making them dynamic:

AWS_ACCOUNT_ID

CI_ENVIRONMENT_NAME

AWS_REGION

APP_NAME

# Assessment Phase 4

This ansible playbook uses inventory.ini and vars.yml as environment variableswhich is encrypted by ansible-vault, will install docker engine (since the artifacts are docker images) and gitlab-runner service on target machine.

For using this playbook you need to update the inventory.ini file and alo create a var.yml file containing following envs:

gitlab_runner_description: "Local GitLab Runner"

gitlab_runner_tags: "zuru,aws,production,development"

gitlab_runner_executor: "docker"

gitlab_registration_url: "https://gitlab.com/"

gitlab_registration_token: "YOUR_ACTUAL_REGISTRATION_TOKEN"


Then this file must be encrypted by ansible-vault and a password must be defined:

ansible-vault encrypt vars.yml

For running the playbook run the following commands:

for remote host: ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --ask-vault-pass

for localhost: ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --ask-vault-pass --connection=local
