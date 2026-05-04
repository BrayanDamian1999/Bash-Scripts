# Bash Scripting Project

In this project, I will learn how to write and execute shell scripts. The main objective is to gain hands-on experience in automating tasks, managing system processes, and handling file manipulation using shell commands. By the end of the project, I aim to be proficient in shell scripting, with a good understanding of its practical applications.

## Topics Covered

- Basics of Shell Commands
- Creating and Running Shell Scripts
- File and Directory Operations
- Automating Tasks
- Handling User Inputs
- Working with Variables and Loops

## Table of Contents

- [Overview](#overview)
- [Scripts](#scripts)
- [Usage Examples](#usage-examples)
- [License](#license)

## Overview

This repository contains a collection of Bash scripts designed for system administration, server management, backups, and DevOps automation tasks. Each script is self-contained and can be executed independently on Linux environments.

## Scripts

| Script | Description |
|--------|-------------|
| `.aliases` | Custom shell aliases to speed up common terminal commands. |
| `backup.sh` | Automates file and directory backups. |
| `gitlab_preupgrade.sh` | Performs pre-upgrade checks and tasks before upgrading GitLab. |
| `gitup.sh` | Helper script to streamline `git add`, `commit`, and `push` operations. |
| `install_node_exporter.sh` | Installs and configures Prometheus Node Exporter for system metrics. |
| `mount_and_rsync.sh` | Mounts a remote/local volume and syncs data using `rsync`. |
| `newscript.sh` | Template generator for creating new Bash scripts with a standard header. |
| `server-stats.sh` | Displays real-time server statistics (CPU, RAM, disk, uptime). |
| `start_server.sh` | Starts a server or service with predefined configuration. |

## Usage Examples

Before running any script, make sure it has execution permissions:

```bash
chmod +x script_name.sh
```

### Load custom aliases

```bash
source .aliases
```

### Run a backup

```bash
./backup.sh
```

### Check server statistics

```bash
./server-stats.sh
```

### Install Node Exporter

```bash
sudo ./install_node_exporter.sh
```

### Generate a new script from template

```bash
./newscript.sh my_new_script
```

### Sync data with rsync

```bash
./mount_and_rsync.sh
```

### Quick git push

```bash
./gitup.sh "Your commit message"
```

### Pre-upgrade checks for GitLab

```bash
sudo ./gitlab_preupgrade.sh
```

### Start the server

```bash
./start_server.sh
```

## License

This project is open source and available for educational purposes.
