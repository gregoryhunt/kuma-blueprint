network "local" {
  subnet = "10.50.0.0/16"
}

variable "kuma_cp_network" {
  default     = "local"
  description = "Network name that the Kuma control panel is connected to"
}

module "kuma_cp" {
  source = "../"
}
