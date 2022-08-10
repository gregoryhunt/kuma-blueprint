Feature: Kuma Control Pane
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly

Scenario: Simple Control Pane
  Given I have a running blueprint at path "./example"
  Then the following resources should be running
    | name                      | type      |
    | kuma_cp                   | container |
  And a HTTP call to "http://kuma-cp.container.shipyard.run:5681" should result in status 200
  When I run the script
    ```
    #!/bin/bash
    if [ -s "$HOME/.shipyard/data/kuma_config/admin.token" ]; then
      exit 0
    else
      echo "Admin token does not exist, or is empty"
      exit 1
    fi
    ```
