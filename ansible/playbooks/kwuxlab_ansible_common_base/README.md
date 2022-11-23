# Kwuxlab-ansible-common-base

This playbook installs and configures a number of base applications
for the target node(s).

- SSH
  - Add the specified `target_public_key` to the node's authorized keys list
- Log Rotation (via logrotate)
- Journalctl (maximum disk usage)
- `git` installation
- `ntp` installation
  - And timezone configuration
- Sudoer user 
  - To be used in subsequent ansible playbooks
- Base target packages (*e.g.* `wget`, `curl`, etc.)

## Requirements

### Variables

1. `target_public_key_filename`: Filename of the target SSH public key to add to the
    node's authorized keys list
2. `default_local_timezone`: Default timezone to be configured on the node
3. `sudoer_user`: Name of the sudoer user to create 
4. `sudoer_group`: Name of the sudoer user to create/manage
5. `target_sudo_defaults`: Configuration of the `ansible-sudo` role. 
    - Note: this must be updated if changing `sudoer_user` or `sudoer_gruop`
6. `target_purge_other_sudoers_files`: By default, all other sudoer files will be
    purged/removed.
7. `target_packages`: List of packages to install/update
8. `journalctl_config`: Log retention configuration for `journalctl`
9. `target_git_version`: Target git version to install
10. `target_logrotate_scripts`: List of logrotate scripts to be generated.