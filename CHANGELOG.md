# Repository Changelog

This changelog documents all notable changes and the structure of the installation scripts for DevOps tools in this repository.

---

## [Unreleased]
- Ongoing improvements, refactoring, and updates to support new OS versions and tool releases.

---

## [2025-11-19]
### Kubernetes
- Added robust OS detection and kernel module handling (especially for CentOS 9).
- Added `DISABLE_FIREWALLD` and improved firewall logic.
- Refactored system prep into dedicated functions.
- Standardized on Calico networking and default Pod Network CIDR.

### Jenkins
- Automated Java 21 installation, Jenkins repository setup, and service management.

---

## [Earlier]
- Unified script structure for each tool and OS, with clear separation by distribution.
- Improved logging, error handling, and usage instructions across all scripts.
- Updated all scripts to use the latest supported versions of each tool (Kubernetes, Jenkins, GitLab, Nexus, SonarQube).
- Enhanced system preparation: SELinux, swap, firewall, and service management standardized.
- Added/updated README files in each directory with prerequisites, usage, and troubleshooting.
- Initial versions: Automated installation scripts for each tool and OS, handling basic installation and configuration.