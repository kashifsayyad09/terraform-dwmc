data "aws_region" "current" {}

resource "aws_vpc_endpoint" "secretsmanager" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"

  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.subnet_ids

  security_group_ids = [
    module.security_groups.vpce_sg_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "secretsmanager-vpce"
  }
}