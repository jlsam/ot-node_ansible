### Introduction

This [Ansible](https://www.ansible.com/) [playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) and associated files will setup a fresh Linux server and install an Origin Trail v6 test node. Testing was done in a VPS running Ubuntu 18.04 and 20.04. These instructions also assume your [control](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#control-node) system is running a Linux distribution that uses `apt` as the package manager.

See [this file](quick-instructions.md) for quick setup instructions.

Recent versions of Debian [switched](https://wiki.debian.org/MySql) from MySQL to MariaDB. ot-node bash installer uses MySQL and one of the commands is not compatible with MariaDB. If the Origin Trail provides support for MariaDB in the future I will endeavor to make the necessary changes, but for now Debian is not supported.

### SSH configuration
This setup assumes a working `config` file in ~/.ssh, in the control system. I include a sample file and simple instructions [here](.ssh/).

>Note: the `.ssh/` directory in this repository is just a placeholder for the `config` file and instructions. The folder is not necessary to run the playbooks.

The SSH authentication is done via a SSH key pair. During execution the playbook will disable password authentication. If you prefer to use passwords, [which is widely discouraged](https://sectigo.com/resource-library/what-is-an-ssh-key#:~:text=An%20SSH%20key%20is%20a,and%20scalable%20method%20of%20authentication.), you will have to modify the files accordingly yourself.

This setup also assumes that your VPS provider allows for the placement of a SSH public key when the VPS is created. If this is not the case, you will have to [create and transfer](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04) over the public key manually before running the playbook.

### Install ansible
> Note: These playbooks are not compatible with Ansible 2.9.x. Testing was done with Ansible v2.12.2.

Official Ansible installation instructions are provided [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

But in a nutshell, run these commands:

 $ `sudo apt update`

 $ `sudo apt install software-properties-common`

 $ `sudo add-apt-repository --yes --update ppa:ansible/ansible`

 $ `sudo apt install ansible`

Ansible is installed in the control system only. There are no installation steps for the remote servers. Ansible connects to the remote servers via SSH and uses the existing Python libraries to execute the playbooks.

#### Install additional collection community.general

This playbook uses the plugin [community.general.npm](https://docs.ansible.com/ansible/latest/collections/community/general/npm_module.html). To install, issue the command

  $`ansible-galaxy collection install community.general`

This collection is also required for the locale plugin detailed below.

### Clone this repository

Either use GitHub suggested options (the green 'Code' button on the top right side of the page) or navigate to the destiny directory in the control system and type in a terminal

  $ `git clone jlsam/ot-node_ansible`

### Ansible hosts file configuration

Ansible [hosts](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) file contains an inventory of servers, server groups and optionally server-specific variables. Ansible uses the aliases in [~/.ssh/config](.ssh/config) and associated settings to establish SSH connections.

The [`hosts`](hosts) file is located at the root of the playbook directory, instead of the default location `/etc/ansible/hosts`, for the sake of convenience. It's possible to change this default in [ansible.cfg](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-host-list). This way the parameter `-i hosts` can be ommited when executing playbooks.

The included [`hosts`](hosts) file demonstrates several different ways to setup the inventory:

- Ungrouped servers can be placed directly under the top level `hosts:`

- Servers that make sense to manage in groups can be nested within a group name, which in turn is nested in `children:`.

- If a [role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) applies only to a subset of the inventory, you can create more groups under `children:`. These groups can contain both existing individual servers and also existing server groups (ex. `ot_nodes:`). The playbook file can include one or more of these names as the target(s) for the playbook execution.

The `hosts` file can store **server-specific variables**. Alternatively, these variables can be stored in .yml files under [`host-vars`](host-vars/), each filename matching the server alias. Examples are provided for both situations. If the hosts file becomes too unwieldy and confusing with many servers and variables, the `host-vars` directory is probably the best option.

I recommend you pick one approach and take care not to declare the same variable in different locations, otherwise you can run into problems because of [variable precedence](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable). In any case, two variables need to be declared for the playbook to work, see [host_vars/v6_testnet.yml](host_vars/v6_testnet.yml) for a template.

- `origin_trail_wallet:` The operational wallet public key (address).
- `origin_trail_wallet_privkey:` The operational wallet private key.

>Ansible also supports a [specific directory/file](roles/origin_trail/vars/) structure for **role-specific variables**, i.e., variables that are common to all servers running the same setup (role).

### Storing private keys and other sensitive data

Instead of storing sensitive data like passwords and private keys in plain text, this setup uses the control system's Keyring to store those values. I find this solution more convenient than [Ansible Vault](https://docs.ansible.com/ansible/2.9/user_guide/vault.html#encrypt-string-for-use-in-yaml) because there is no need for password files or typing a password to unlock the vault everytime the playbook is executed. It also makes for simpler code.

To store and use values in the Keyring, follow these steps:
1. Install python-keyring $`sudo apt install python-keyring`

2. Create the password entry in the Keyring $`keyring set myservice user`. In the examples, 'myservice' is 'origin_trail' and 'user' is 'node_privk'.

3. Declare the variable using the template `"{{ lookup('keyring','myservice user') }}"`

### Select graph database installer

Either GraphDB or Blazegraph DB needs to be installed. Edit [`roles/origin_trail/vars/main.yml`](roles/origin_trail/vars/main.yml) accordingly. Blazegraph DB is the default selection.

- Blazegraph DB is downloaded from an offical source and requires no further steps.

- GraphDB requires the installer to be obtained manually and copied to [`roles/origin_trail/files/`](roles/origin_trail/files). [Instructions to obtain the file](https://docs.origintrail.io/dkg-v6-beta/testnet-node-setup-instructions/setup-instructions-dockerless) can be found in the offical Origin Trail documentation.

To install different databases in different testnet servers, you will have to move the `database:` variable from [`roles/origin_trail/vars/main.yml`](roles/origin_trail/vars/main.yml) to either the hosts file or [`host-vars/`](host-vars/), as detailed above.

### Optional: set locale

Assign the variable `locale:` to match your keyboard layout in [roles/basic/vars/main.yml](roles/basic/vars/main.yml).

If you don't care about this setting, you can skip it - in [roles/common/tasks/main.yml](roles/common/tasks/main.yml), find the task 'Update locale' and set the value of `tags:` to 'never'.

### Optional: Server hardening roles

I suggest using server hardening roles to help secure the servers:

- [ansible-hardening](https://docs.openstack.org/ansible-hardening/latest/getting-started.html) by OpenStack.

- [Any of these](https://galaxy.ansible.com/search?keywords=os-hardening&deprecated=false&order_by=-relevance) from Ansible Galaxy.

### Execute the playbook

At the root of the repository, run

  $`ansible-playbook manage_servers.yml -i hosts`

### Acknowledgements

The installation procedure was based in [the offical bash script installer](https://github.com/OriginTrail/ot-node/blob/v6/develop/installer/installer.sh) and had help of community members in [Telegram](https://t.me/otnodegroup).
