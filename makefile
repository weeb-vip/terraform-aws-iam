docs:
	rm -rf modules/*/.terraform modules/*/.terraform.lock.hcl
	terraform-docs markdown . --output-file README.md
