container "kuma_cp" {
    network {
        name = "network.local"
    }

    image {
        name = "kumahq/kuma-cp:1.7.1"
    }

    command = ["run"]

  port {
    local = 5681
    remote = 5681
    host = 5681
    open_in_browser = "/gui"
  }

}