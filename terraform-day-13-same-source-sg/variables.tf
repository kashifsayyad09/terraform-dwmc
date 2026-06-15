variable "sg_rule" {
  description = "adding_values"
  type = list(string)
  default = [ "22","80","443","3000","5000","3306","5432" ]
}