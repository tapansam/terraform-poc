
resource "local_file" "ssh_pvt_key" {
  filename        = "../../ansible/playbooks/adv.pem"
  content         = <<EOF
${tls_private_key.main.private_key_pem}
EOF
  file_permission = 400
}

resource "local_file" "ansible_hosts" {
  filename = "../../ansible/playbooks/adv.hosts"
  content  = <<EOF
[adv:vars]
ansible_ssh_private_key_file=adv.pem

[adv]
${substr(azurerm_dns_a_record.adv.fqdn, 0, length(azurerm_dns_a_record.adv.fqdn) - 1)}
EOF
}
