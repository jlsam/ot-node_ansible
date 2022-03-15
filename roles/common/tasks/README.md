### Overview

- The `common` role is automatically included everytime the `origin_trail` role is executed because it is set as a dependency in [`roles/origin_trail/meta/main.yml`](roles/origin_trail/meta/main.yml).

- This role includes tasks that are common to every server setup. For example, if a role to setup mainnet servers is included in the future, those servers will also share this role. This makes for re-usable code that is easier to maintain.

- The two includes handle swap file and ufw setup. These are two very conserved tasks (they pretty much do not require any maintenance) and therefore keep the main file shorter and easier to edit.

- Since the `common` role is executed as a dependency, it inherits the variables from the parent role. Specifically, the variable containing the ports to open in UFW is set in [`roles/origin_trail/vars/main.yml`](roles/origin_trail/vars/main.yml).
