template "control_config" {
  source      = "./config/kuma_cp.tmpl"
  destination = "${data("kuma_config")}/kuma_cp.tmpl"
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
    open_in_browser = "/gui"
  }

  volume {
    source      = data("kuma_config")
    destination = "/etc/kuma"
  }

  health_check {
    timeout = "60s"
    http    = "http://localhost:5681"
  }

}

sidecar "tools" {
  target = "container.kuma_cp"

  image {
    name = "shipyardrun/tools:v0.7.0"
  }

  command = ["tail", "-f", "/dev/null"]

  volume {
    source      = data("kuma_config")
    destination = "/etc/kuma"
  }
}

template "bootstrap" {
  source = <<-EOF
  #!/bin/bash

  curl -s http://localhost:5681/global-secrets/admin-user-token | jq -r .data | base64 -d > /etc/kuma/admin.token
  EOF

  destination = "${data("kuma_config")}/bootstrap.sh"
}

exec_remote "bootstrap" {
  target = "sidecar.tools"

  cmd = "sh"
  args = [
    "/etc/kuma/bootstrap.sh"
  ]
}

output "KUMA_TOKEN" {
  value = "$(cat ${data("kuma_config")}/admin.token)"
}

output "KUMA_TOKEN_LOCATION" {
  value = "${data("kuma_config")}/admin.token"
}