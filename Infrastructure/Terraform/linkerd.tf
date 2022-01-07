# Create Linkerd
# https://github.com/Azure-Terraform/terraform-helm-linkerd
module "helm_release_linkerd" {
    source = "github.com/Azure-Terraform/terraform-helm-linkerd.git"

    # required values
    chart_version               = "2.10.1"
    ca_cert_expiration_hours    = 8760  # 1 year
    trust_anchor_validity_hours = 17520 # 2 years
    issuer_validity_hours       = 8760  # 1 year (must be shorter than the trusted anchor)

    # optional values
    additional_yaml_config = yamlencode(
        { 
            
        })
}