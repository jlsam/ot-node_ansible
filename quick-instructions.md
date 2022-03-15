### Short version / I know the basics instructions

   1. Add the server's details to your local `~/ssh/config` file. Make sure you can manually connect to the server using a SSH key.

   2. Install Ansible and the `community.general` collection:
   
    $ sudo apt update

    $ sudo apt install software-properties-common

    $ sudo add-apt-repository --yes --update ppa:ansible/ansible

    $ sudo apt install ansible

    $ ansible-galaxy collection install community.general

   3. Clone this repository:

    $ git clone jlsam/ot-node_ansible

   4. Edit the 'hosts' file at the root of the repository to include the alias you set for the server in step 1. The most basic example for 1 server would be

    all:
      hosts:
        v6_testnet:

   5. Install python-keyring

     $ sudo apt install python-keyring

   6. Save the operational wallet private key to your keyring

    $ keyring set myservice user

   7. Set the operational wallet address and private key to variables in `host_vars/v6_testnet.yml` (ssh_alias.yml). Set the lookup variable names to match what you chose in step 6.

   8. Choose which Graph database you want to run in [`roles/origin_trail/vars/main.yml`](roles/origin_trail/vars/main.yml). If you choose GraphDB, place the installer `graphdb-free-9.10.1-dist.zip` in [`roles/origin_trail/files`](roles/origin_trail/files). Blazegraph is the default and requires no other action.

   9. Execute the playbook in the root directory of the repository:

    $ ansible-playbook manage_servers.yml -i hosts
