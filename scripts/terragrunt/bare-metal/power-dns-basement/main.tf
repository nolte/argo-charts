
resource "powerdns_zone" "smart_home" {
  name        = "smart-home.k8sservices.local."
  kind        = "Native"
}

#resource "powerdns_record" "foobar" {
#  zone    = "example.com."
#  name    = "www.example.com."
#  type    = "A"
#  ttl     = 300
#  records = ["192.168.0.11"]
#}

provider "powerdns" {
}