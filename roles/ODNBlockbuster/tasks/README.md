This role will install and start [ODNBlockbuster](https://github.com/ethsplainer/ODNBlockbuster) along with the main software.

The role is setup to use a different OMDB API key for each server instance, to avoid refused connections due to requesting too many connections with a single key.

To get a new OMDB API key, follow [this link](https://www.omdbapi.com/apikey.aspx).

For every server, you need to either:
- declare `omdb_apikey:` in [host_vars](host_vars/)/server_alias.yml
- declare `omdb_apikey:` in the `hosts` file, under each server alias

This follows the principles for server-specific variables explained in the [main
README document](https://github.com/jlsam/ot-node_ansible#ansible-hosts-file-configuration).

If you would rather to use the same OMDB API key for every server, you can [override](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#understanding-variable-precedence) the key variable by running the playbook with

`ansible-playbook manage_servers.yml -i hosts -e "omdb_apikey=your-key-here"`

Log rotation is set in the `common` role, by editing `/etc/systemd/journald.conf`
