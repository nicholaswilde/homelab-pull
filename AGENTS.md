# Homelab Pull Project Overview

This project is an Ansible automation repository designed for managing a homelab environment using a GitOps-style approach with `ansible-pull`. Instead of pushing configurations from a central control node, managed nodes (e.g., homelab containers or VMs) periodically pull this repository and execute Ansible playbooks locally to apply their configurations.

## Key Technologies

*   **Ansible:** For configuration management and automation.
*   **ansible-pull:** The core mechanism for GitOps, allowing managed nodes to pull and apply configurations.
*   **Ansible Vault:** For encrypting sensitive data (e.g., API keys, passwords) within the repository.
*   **Task (Taskfile.dev):** A task runner used for various development and maintenance operations, including linting, dependency management, and documentation.
*   **Python:** Used for the dynamic inventory script.
*   **Docker:** Used for building and serving documentation.

## Architecture

The project is structured around Ansible roles and playbooks:

*   **`playbook.yml`:** The main playbook that orchestrates the execution of various roles.
*   **`local.yml`:** An entry-point playbook that dynamically adds hosts to groups based on `host_vars` and then imports `playbook.yml`. This is the playbook executed by `ansible-pull`.
*   **`roles/`:** Contains modular Ansible roles for specific functionalities (e.g., `ansible-pull`, `linux_instance_generic`, `update_apt`, `clean`).
*   **`host_vars/`:** Stores host-specific variables, including `pull_groups` which determine which roles apply to a given host.
*   **`group_vars/`:** Contains variables applicable to all hosts or specific groups.
*   **`inventory`:** A dynamic inventory script written in Python that generates the Ansible inventory based on the `host_vars` files.
*   **`requirements.yaml`:** Specifies the Ansible collections required for the project.

## Building and Running

### Initial Setup on a Managed Node

To set up a new managed node, follow these steps as outlined in the `README.md`:

1.  **Copy Host Variables:**
    ```shell
    cp host_vars/.template.yaml.tmpl host_vars/<hostname>.yaml
    ```
    Then, edit `host_vars/<hostname>.yaml` to configure the host.

2.  **Bootstrap Script:**
    ```shell
    (
      sudo apt update && \
      sudo apt install -y curl && \
      OWNER_NAME="nicholaswilde" && \
      REPO_NAME="homelab-pull" && \
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/${OWNER_NAME}/${REPO_NAME}/refs/heads/main/scripts/bootstrap.sh)"
    )
    ```

3.  **Run `ansible-pull`:**
    ```shell
    ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n), "
    ```

### Local Development and Testing

The `Taskfile.yml` defines several useful commands for local development:

*   **Install/Update Ansible Collections:**
    ```shell
    task reqs
    ```

*   **Run Ansible Lint:**
    ```shell
    task lint
    ```

*   **Generate Vault Password File:**
    ```shell
    task gen-passwd
    ```
    This generates a random password and saves it to `~/.config/homelab-pull/password`, which is used by `ansible.cfg` for Ansible Vault.

*   **Build Documentation:**
    ```shell
    task build
    ```

*   **Serve Documentation Locally:**
    ```shell
    task serve
    ```
    This starts a development server for the documentation at `http://0.0.0.0:8000`.

*   **Run a Test Docker Container (for manual testing):**
    ```shell
    task test
    ```

### Running Ansible Locally (for testing changes)

To test Ansible changes locally without `ansible-pull`, you can use the `ansible-playbook` command with the dynamic inventory:

```shell
ansible-playbook -i inventory local.yml --limit <hostname>
```
Replace `<hostname>` with the name of a host defined in your `host_vars` (e.g., `pi00`).

## Development Conventions

*   **Ansible Roles:** The project heavily utilizes Ansible roles for organizing automation tasks into reusable and modular units.
*   **Variable Management:** Host-specific variables are managed in `host_vars/` files, and global variables are in `group_vars/all.yaml`.
*   **Ansible Vault:** Sensitive information is encrypted using Ansible Vault, with the vault password file configured in `ansible.cfg`.
*   **Linting:** `ansible-lint` is used to ensure code quality and adherence to Ansible best practices.
*   **Task Runner:** `Task` is used to standardize common development and operational tasks.
*   **Dynamic Inventory:** A custom Python script (`inventory`) is used to generate the Ansible inventory dynamically based on host configurations.
