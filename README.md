# mentoring
Mentoring in Shell scripting and programming for Junior and Mid-level developers.

# 🛠️ Decommission Script for IBM Spectrum Protect (TSM)

This repository contains a shell script created during a mentoring session to **automate and streamline the decommissioning process** of *Nodes* and *VMs* in **IBM Spectrum Protect (TSM)**.

The script is written in **Shell Script** and is intended for administrators working in Linux environments that interface with TSM.

---

## 📌 Purpose of the Script

This script assists administrators by guiding them through the required steps to safely decommission a Node or VM in TSM. It includes:

- Validation of the Node or VM name.
- Display of key information prior to removal.
- Execution of the necessary administrative commands to:
  - **Disable the node**
  - **Remove the node**
  - **Clean up related resources**
- Reduction of human error through automation and confirmations.

---

## 🚀 Features

- Interactive menu with user prompts.
- Execution of IBM Spectrum Protect administrative commands.
- Pre-removal checks and validation.
- Optional logging support.
- Clear output messages at every step.

---

## 🧩 Requirements

Before running the script, ensure that:

- You have administrative access to the TSM server.
- The `dsmadmc` command-line tool is installed and configured.
- You have valid administrative credentials.
- You need creat a credential file calles .credent, with id and password on the same line, separated by comma.
- The script has execution permissions:

```bash
chmod +x decom.sh

