variable "allowed_ports" {
    description = "key-value adding"
    type = map(string)
    default = {
      22 = "0.0.0.0/24"
      80 = "0.0.0.0/0"
      443 = "10.0.0.0/16"
      3000 = "0.0.0.0/0"
    }
  
}