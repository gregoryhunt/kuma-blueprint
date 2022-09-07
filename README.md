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
default: kumahq/kuma-cp:1.8.0 
Version of the Kuma control plan to run

## Outputs

## KUMA_TOKEN_LOCATION

Location of the Kuma control panel admin token

## KUMA_TOKEN

Kuma control panel admin token
