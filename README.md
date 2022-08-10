# Kuma Control Plane Shipyard Repo

To run the example

```
shipyard run ./example
```

To use this blueprint in your own modules or blueprints

```javascript
network "local" {
  subnet = "10.50.0.0/16"
}

variable "kuma_cp_network" {
  default     = "local"
  description = "Network name that the Kuma control panel is connected to"
}

module "kuma_cp" {
  source = "github.com/gregoryhunt/kuma-bluprint"
}
```

## Variables

### kuma_cp_network

required: true
Name of the network that the Cuma control plane is attached to

### kuma_cp_version

required: false
default: kumahq/kuma-cp:1.7.1 
Version of the Kuma control plan to run

### kuma_start_gui

required: false
default: false 
Start the Kuma GUI
