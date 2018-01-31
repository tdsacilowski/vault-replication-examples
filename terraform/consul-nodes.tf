resource "aws_instance" "consul" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.testing.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.vault.id}"

  tags {
    Name     = "${var.environment_name}-consul-server"
    ConsulDC = "replication-testing"
  }

  user_data = "${data.template_file.consul.rendered}"
}

data "template_file" "consul" {
  template = "${file("${path.module}/templates/userdata-consul.tpl")}"

  vars = {
    tpl_aws_region      = "${var.aws_region}"
    tpl_s3_bucket_name  = "${var.s3_bucket_name}"
    tpl_consul_zip_file = "${var.consul_zip_file}"
  }
}
