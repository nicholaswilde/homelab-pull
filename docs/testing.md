# :test_tube: Testing

## :whale2: Testing Using Docker

Launch into a shell in a Debian Docker container.

```shell
docker run -it --rm -h "$(uname -n)" debian /bin/bash
```

In the Docker container.

```shell
cd ~ && \
apt update && \
apt install curl -y && \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nicholaswilde/homelab-pull/refs/heads/main/scripts/bootstrap.sh)" && \
export PATH=$PATH:$HOME/.local/bin
```

Test the playbook.

```shell
ansible-pull -U http://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
```

---

## :test_tube: Testing with a Specific Branch

To test changes from a specific branch before they are merged into `main`, you can modify the `ansible-pull` command to
target that branch.

1.  **Identify the branch name:** For example, `my-feature-branch`.

2.  **Modify the `ansible-pull` command:**

    Change the URL in the `ansible-pull` command from `https://github.com/nicholaswilde/homelab-pull.git` (which
    defaults to the `main` branch) to point to your specific branch using the `-C` or `--checkout` option, or by
    specifying the branch in the URL if your `ansible-pull` version supports it directly for playbook
    repositories (though `-C` is more standard for specifying a branch).

    **Using `-C` (checkout) option (recommended):**
    This tells `ansible-pull` to checkout the specified branch after cloning.

    ```shell
    ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -C my-feature-branch -i "$(uname -n),"
    ```

    Replace `my-feature-branch` with the actual name of your branch.

3.  **Bootstrap Script (if applicable for new setups):**
    If you are bootstrapping a new node and want it to use a specific branch from the start for the initial
    `requirements.yaml` and scripts, you would need to modify the URLs within the bootstrap script itself before
    running it. For example, changing `refs/heads/main` to `refs/heads/my-feature-branch` in the script's URL paths:

    ```shell
    OWNER_NAME="nicholaswilde"
    REPO_NAME="homelab-pull"
    BRANCH_NAME="my-feature-branch" # Specify your branch
    # ...
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/${OWNER_NAME}/${REPO_NAME}/refs/heads/${BRANCH_NAME}/scripts/bootstrap.sh)"
    ```
    And similarly for the `REQUIREMENTS_URL` inside the script if it's hardcoded, or ensure your `ansible-pull` command
    used post-bootstrap points to the correct branch. The `ansible-pull` command shown above is the primary way to
    control the playbook branch after initial setup.

This allows you to test your changes in isolation on one or more managed nodes before merging to `main`.
