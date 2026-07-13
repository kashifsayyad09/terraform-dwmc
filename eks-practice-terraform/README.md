# Practice EKS Cluster (VPC + EKS via Terraform)

Uses official `terraform-aws-modules/vpc` and `terraform-aws-modules/eks` modules.

## What it creates
- VPC with 2 public + 2 private subnets across 2 AZs
- 1 NAT gateway (single, to save cost)
- EKS cluster (default v1.30) with 1 managed node group (t3.medium, 1-3 nodes)
- Public + private API endpoint access

## Prereqs
- Terraform >= 1.5
- AWS CLI configured (`aws configure`) with an IAM user/role that has EKS/EC2/VPC/IAM permissions
- kubectl installed

## Usage
```bash
cp terraform.tfvars.example terraform.tfvars   # edit values if needed

terraform init
terraform plan
terraform apply

# connect kubectl to the new cluster
aws eks update-kubeconfig --region ap-south-1 --name practice-eks

kubectl get nodes
```

## Cost warning
This is NOT free-tier:
- EKS control plane: ~$0.10/hr (~$73/month) flat, regardless of usage
- 2x t3.medium nodes: ~$0.083/hr each
- 2x NAT gateways (one per AZ): ~$0.045/hr each + data processing

**Destroy it when you're done practicing:**
```bash
terraform destroy
```

## Using an existing IAM role for master + worker access
`ssm_role_arn` (default `arn:aws:iam::724208363870:role/ssm-role-eks`) is:
- Given **cluster-admin access** on the control plane via an EKS access entry (`AmazonEKSClusterAdminPolicy`) — so anyone who can assume this role can run kubectl against the cluster.
- Reused as the **worker node IAM role** (`create_iam_role = false`), instead of the module creating a fresh one.

For the node group to actually launch with this role, `ssm-role-eks` must already have:
- A trust policy allowing `ec2.amazonaws.com` to assume it
- These managed policies attached: `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, `AmazonEC2ContainerRegistryReadOnly`, and (since it's named for SSM) `AmazonSSMManagedInstanceCore`

If the role is missing any of these, nodes will fail to join the cluster — check `terraform apply` output and the node group's EC2 instance logs / SSM Session Manager if that happens.

## Notes for interview prep
- `enable_cluster_creator_admin_permissions = true` gives your IAM identity cluster-admin via access entries (new EKS access management, replaces the old aws-auth configmap approach).
- Subnets are tagged with `kubernetes.io/role/elb` and `internal-elb` so the AWS Load Balancer Controller can auto-discover them later if you add ingress.
- Swap `single_nat_gateway = true` → `one_nat_gateway_per_az = true` in `vpc.tf` if you want to simulate a real HA setup (costs more).
