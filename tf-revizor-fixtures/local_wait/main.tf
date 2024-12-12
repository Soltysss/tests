
variable "run_id" {
  default = "run-jyslljjfs84jsl111127777888"
}


variable "sleep_time" {
  default = 5
}

variable "sens" {
  default   = "xxxxxx"
  sensitive = true
}

resource "random_integer" "timeout" {
  min = 30
  max = 180

  keepers = {
    run_id = "Possibly sensitive ${var.run_id}!!"
  }
}



resource "null_resource" "wait" {
  triggers = {
      run_id = "This can be sensitive ${var.run_id}!"
      name   = var.sens
  }
  provisioner "local-exec" {
    command = "sleep ${var.sleep_time}"
     environment = {
       FOO = "bar"
       BAR = 1
       BAZ = "true"
     }
  }
}


module "local-wait" {
  source = "./modules/local-wait"
  secret = var.sens
}

output "very_long" {
  value = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
}

output "test" {
  value = "laborum ${var.sens}"
  sensitive = true
}

output "senc_out" {
  value       = "xxxxxx"
  description = "my sensitive output"
  sensitive   = true
}

output "module_res" {
  value = "${module.local-wait.the_id} xxxxxx"
  sensitive = true
}



output "sleeped_for" {
  value = "${var.sleep_time} this is suppose to be sensitive"
}

output "run_id" {
  value = "${var.run_id} this is suppose to be sensitive. real value is 555555"
}
  
