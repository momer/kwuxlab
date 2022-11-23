#!/usr/bin/env bash
# View, encrypt, edit
default_command="view"
COMMAND="${COMMAND:-$default_command}"

# kwuxlab env
default_kwuxlab_env="test"
KWUXLAB_ENV="${KWUXLAB_ENV:-$default_kwuxlab_env}"

playbooks=("kwuxlab_ansible_service_ansible_awx"
"kwuxlab_ansible_common_tailscale"
"kwuxlab_ansible_service_postgresql"
"kwuxlab_ansible_service_vault"
"kwuxlab_ansible_service_consul"
"kwuxlab_ansible_service_consul_acls"
"kwuxlab_ansible_service_nomad")

for playbook in "${playbooks[@]}"
do
  :
  ansible-vault \
    "${COMMAND}" \
    playbooks/"${playbook}"/vars/"${KWUXLAB_ENV}"_environment.yml \
    --vault-password-file password_file."${KWUXLAB_ENV}".txt
done