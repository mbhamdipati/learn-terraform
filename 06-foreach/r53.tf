resource "aws_route53_record" "roboshop" {
for_each = var.instances
  zone_id = var.zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.roboshop[each.key].private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "frontend" {
  count   = contains(keys(var.instances), "frontend") ? 1 : 0
  zone_id = var.zone_id
  name    = "${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.roboshop["frontend"].public_ip]
   allow_overwrite = true
}
