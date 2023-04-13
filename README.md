# aws-infra
 ## instructions:
 1. terraform fmt && terraform init
 2. terraform plan
 3. terraform apply (this step will ask for a profile, region and vpc_tag_name)
 4. go to AWS, sign in with the dev admin user or demo admin user
 5. go to VPCs, and you will see all new created resources
 6. if want to create multiple vpc, git clone to another dir and do the above again
 7. terraform destroy

 ## The command to import the certificate：
 aws acm import-certificate --certificate fileb://demo_yumenghuang_me.crt \
      --certificate-chain fileb://demo_yumenghuang_me.ca-bundle \
      --private-key fileb://private.key \
      --region us-west-1 \
      --profile demo
