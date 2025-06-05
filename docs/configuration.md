# :gear: Configuration

Find the hostname of the managed node.

!!! code

    ```shell
    uname -n
    # test-debian-1
    ```

Create a `host_vars` file with the file name as the hostname, e.g. `host_vars/test-debian-1.yaml`.

!!! code

    ```shell
    cp host_vars/.template.yaml.tmpl host_vars/<hostname>.yaml
    ```

Add the groups the host is a part of to the `pull_groups` list.

!!! abstract "host_vars/hostname.yaml"

    ```yaml
    ---
    ansible_user: root
    pull_groups:
      - lxcs
    ```

Create additional roles if needed.

Update `playbook.yml` with which host groups run which roles.

Update variables that being passed into each role. List of variables can be found under `roles/<role name>/defaults/main.yaml`.
