output "consul-public-ip" {
  value = "${aws_instance.consul.public_ip}"
}

output "consul-private-ip" {
  value = "${aws_instance.consul.private_ip}"
}

output "vault-public-ip" {
  value = "${aws_instance.vault.*.public_ip}"
}

output "vault-private-ip" {
  value = "${aws_instance.vault.*.private_ip}"
}
