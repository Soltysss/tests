resource "terraform_data" "that" {
  count = 30
  input = "something"
}
