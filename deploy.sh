revision="$(cat revision.txt)"

#Generate Terraform plan
terraform -chdir=./terraform plan -out="plan$revision" -var "image_tag=$revision"

#Apply plan
terraform -chdir=./terraform apply --auto-approve plan$revision