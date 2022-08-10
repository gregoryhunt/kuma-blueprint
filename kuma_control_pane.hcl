template "control_config" {
  source      = "./config/kuma_cp.tmpl"
  destination = "${data("kuma_cp")}/kuma_cp.tmpl"
}

container "kuma_cp" {
  depends_on = ["template.control_config"]

  network {
    name = "network.${var.kuma_cp_network}"
  }

  image {
    name = var.kuma_cp_version
  }

  command = ["run"]

  port {
    local           = 5681
    remote          = 5681
    host            = 5681
    #open_in_browser = var.kuma_start_gui ? "/gui" : {}
  }

  volume {
    source      = data("kuma_cp")
    destination = "/etc/kuma"
  }

}
