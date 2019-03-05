variable "list_of_allowed_accounts" {
  type = "list"
  default = ["1111", "2222"]
}

variable "list_of_images" {
  type = "list"
  default = ["alpine", "java", "jenkins"]
}

data "template_file" "ecr_policy_allowed_accounts" {
  count = "${length(var.list_of_allowed_accounts) * length(var.list_of_images)}"

  template = "${file("${path.module}/ecr_policy.tpl")}"

  vars {
    account_id = "${var.list_of_allowed_accounts[count.index / length(var.list_of_images)]}"
    image      = "${var.list_of_images[count.index % length(var.list_of_images)]}"
  }
}

resource "aws_ecr_repository_policy" "repo_policy_allowed_accounts" {
  count = "${data.template_file.ecr_policy_allowed_accounts.count}"

  repository = "${var.list_of_images[count.index % length(var.list_of_images)]}"
  policy = "${data.template_file.ecr_policy_allowed_accounts.*.rendered[count.index]}"
}