### Overview

Role dependencies in `meta/main.yml` [are run first](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#using-roles-at-the-play-level) during playbook execution.

This topic is developed in more detail [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#using-role-dependencies).

### Common tasks

In this particular setup the [common role](roles/common/tasks) contains a number of tasks that are important for every server type. They are executed before the specific tasks related to the primary role.

This allows to reuse code that is shared across different server types - some tasks are the same whether we're setting up a mainnet or a testnet server.
