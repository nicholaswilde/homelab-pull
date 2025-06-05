# :stethoscope: Troubleshooting

Troubleshooting can be done by passing setting `debug_enabled` to `true` or passing in the `-vvv` argument.

!!! code "Debug enabled"

    ```shell
    ansible-pull -e "debug_enabled=true" -U http://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
    ```

!!! code "Verbose"

    ```shell
    ansible-pull -vvv -U http://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
    ```

Individual task files can be tested by using tags, such as `test`.


!!! abstract ""

    ```yaml
    - name: Setup tmux
      ansible.builtin.include_tasks: 
        file: "tmux.yaml"
        apply:
          tags:
            - tmux
            - test
      tags:
        - always
    ```

!!! code "Tag `test`"

    ```shell
    ansible-pull --tags test -U http://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n)," 
    ```
