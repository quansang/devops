module "route53" {
  source = "../../modules/route53"
  #basic
  project = var.project
  env     = var.env

  #route53
  route53_zone = { domain_name = var.domain }
  route53_alias_records = [
    {
      name = var.domain
      alias = {
        dns_name = module.alb.alb_dns_name
        zone_id  = module.alb.alb_zone_id
      }
    }
  ]
}
