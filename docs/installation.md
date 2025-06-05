# :hammer_and_wrench: Installation

### :paperclips: Dependencies

Install dependencies on the managed node.

!!! code

    ```shell
    (
      sudo apt update
      sudo apt install -y curl
    )
    ```

### :hiking_boot: Bootstrap

Use the bootstrap script to finish setting up the managed node by installing [`ansible-core`][10] as well as the
required collections.

!!! warning

    Always inspect a shell script before running it!

Set variables used in the script.

!!! code

    ```shell
    (
      OWNER_NAME="nicholaswilde"
      REPO_NAME="homelab-pull"

      REQUIREMENTS_URL="https://raw.githubusercontent.com/${OWNER_NAME}/${REPO_NAME}/refs/heads/main/requirements.yaml"
      PASSWORD_PATH="${HOME}/.config/homelab-pull/password"
    )
    ```

Run the script.

!!! code

    ```shell
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/${OWNER_NAME}/${REPO_NAME}/refs/heads/main/scripts/bootstrap.sh)"
    ```

!!! note

    Debian based systems install ansible-core via `apt`, else via `pipx`.

Add the `pipx` `bin` dir temporarily to `PATH`, if applicable.

!!! code

    ```shell
    export PATH=$PATH:$HOME/.local/bin
    ```

Alternatively, add it permanently to `.bashrc`, if applicable.

!!! code

    ```shell
    (
      echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc && \
      source ~/.bashrc
    )
    ```
