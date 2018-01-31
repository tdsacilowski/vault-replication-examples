resource "aws_instance" "vault" {
  count                       = 3
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.testing.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.vault.id}"

  tags {
    Name     = "${var.environment_name}-vault-server-${count.index}"
    ConsulDC = "replication-testing"
  }

  user_data = "${data.template_file.vault.rendered}"
}

data "template_file" "vault" {
  template = "${file("${path.module}/templates/userdata-vault.tpl")}"

  vars = {
    tpl_aws_region      = "${var.aws_region}"
    tpl_kms_key         = "${aws_kms_key.vault.id}"
    tpl_s3_bucket_name  = "${var.s3_bucket_name}"
    tpl_vault_zip_file  = "${var.vault_zip_file}"
    tpl_consul_zip_file = "${var.consul_zip_file}"
  }
}
