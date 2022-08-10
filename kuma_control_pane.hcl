template "control_config" {
  source      = file("${file_dir()}/config/kuma_cp.tmpl")
  destination = "${data("kuma_config")}/kuma-cp.defaults.yaml"
}

certificate_ca "kuma_cp_ca" {
  output = data("kuma_certs")
}

certificate_leaf "kuma_cp_control_pane" {
  depends_on = ["certificate_ca.kuma_cp_ca"]

  ca_key  = "${data("kuma_certs")}/kuma_cp_ca.key"
  ca_cert = "${data("kuma_certs")}/kuma_cp_ca.cert"

  ip_addresses = ["127.0.0.1"]
  dns_names = [
    "localhost",
    "kuma-cp.container.shipyard.run",
  ]

  output = data("kuma_certs")
}

copy "certs" {
  depends_on = ["certificate_leaf.kuma_cp_control_pane"]

  source      = data("kuma_certs")
  destination = data("kuma_config")
  permissions = "0777"
}

container "kuma_cp" {
  depends_on = ["template.control_config", "certificate_leaf.kuma_cp_control_pane"]

  network {
    name = "network.${var.kuma_cp_network}"
  }

  image {
    name = var.kuma_cp_version
  }

  command = [
    "run"
  ]

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

  env {
    key   = "KUMA_GENERAL_TLS_CERT_FILE"
    value = "/etc/kuma/kuma_cp_control_pane.cert"
  }

  env {
    key   = "KUMA_GENERAL_TLS_KEY_FILE"
    value = "/etc/kuma/kuma_cp_control_pane.key"
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

  until curl --silent --fail http://localhost:5681/global-secrets/admin-user-token; do
    echo "Waiting for admin token generation"
    sleep 1
  done

  curl -v http://localhost:5681/global-secrets/admin-user-token | jq -r .data | base64 -d > /etc/kuma/admin.token
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

output "KUMA_CA" {
  value = "${data("kuma_config")}/kuma_cp_ca.cert"
}
