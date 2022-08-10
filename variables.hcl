variable "kuma_cp_network" {
  default     = "local"
  description = "Network name that the Kuma control panel is connected to"
}

variable "kuma_cp_version" {
  default     = "kumahq/kuma-cp:1.7.1"
  description = "Docker image to use for the Kuma control panel"
}

variable "kuma_start_gui" {
  default = true
  description = "Start the Kuma GUI"
}
