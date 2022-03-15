### Overview

Here we declare **role-specific variables**. These are configuration values that apply to every server instance configured with this role. So if you manage for example 3 testnet servers, the variables declared here will have the same values across all 3 servers. However, mainnet servers may require different values for the same variables - or different variables altogether. Those variables / values should be declared in a separate role for mainnet configuration.

For **server-specific variables** you can use either the [hosts](hosts) file or a file in [host_vars/](host_vars). See the [README](README.md) at the root of this repository for more details.
