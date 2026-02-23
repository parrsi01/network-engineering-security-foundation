# Network Engineering Security Foundation

Enterprise-structured network engineering and network security training repository focused on operational competence on Ubuntu Linux.

## Purpose

This repository is a progressive, version-controlled curriculum for building real-world skills in:

- Linux networking fundamentals and packet flow reasoning
- Network troubleshooting under operational pressure
- Firewalling, DNS, NAT, packet capture, and basic VPN concepts
- Incident ticket triage and SOC-style evidence gathering

## Design Model

The structure mirrors how infrastructure teams work in production:

- `docs/` for reference knowledge and operational concepts
- `labs/` for reproducible exercises with validation and troubleshooting paths
- `incidents/` for ticket-style drills
- `library/` for quick references and checklists
- `Library/` for structured long-form reference sheets (same pattern as existing DevOps/Data Science repos)
- `scripts/` for repeatable simulations and diagnostics
- `configs/` for sample configurations
- `environment/` for Ubuntu VM setup and topology guidance

## Audience

- Junior Network Engineers
- Infrastructure Operations Analysts
- SOC Analysts needing stronger network troubleshooting fundamentals
- Linux administrators transitioning into network operations

## Prerequisites

- Ubuntu Server LTS (fresh install supported)
- `sudo` access
- VS Code integrated terminal or equivalent shell
- Basic Linux CLI familiarity (`cd`, `ls`, `cat`, `sudo`, `systemctl`)

Recommended packages for full lab coverage:

```bash
sudo apt update
sudo apt install -y iproute2 iputils-ping dnsutils net-tools traceroute tcpdump ufw iptables iptables-persistent wireguard-tools curl jq netcat-openbsd
```

## Curriculum Progression

1. Foundations (`docs/fundamentals/`, Labs 01-03)
2. Operational Skills (`docs/troubleshooting/`, Labs 04-08)
3. Security Awareness + Review (`docs/security/`, Lab 09, `incidents/`)
4. Repetition via scripts, validation, and ticket drills

## Lab Standards (Mandatory)

Every lab in `labs/` contains:

- `lab_objective.md`
- `step_by_step_guide.md`
- `full_solution.md`
- `common_errors.md`
- `troubleshooting_tree.md`
- `validation_script.sh` (when command validation is possible)

Each lab also includes:

- Intentional misconfiguration scenario
- Real-world operational failure simulation
- Debugging walkthrough

## Safety Notes

- Labs are designed for local VMs and Linux namespaces where possible.
- Firewall/NAT changes can break SSH or remote access if applied on a live host.
- Use a console session or snapshot before modifying rules on a remote VM.
- `tcpdump` may require `sudo` or capture capabilities.

## What Interviewers Test For

Interviewers typically test whether you can move from symptoms to evidence quickly.

### Junior Network Engineer

- Can you explain the difference between Layer 2 and Layer 3 using real commands?
- Can you validate IP addressing, subnet masks, and default routes without guessing?
- Can you read `ip addr`, `ip route`, `ss`, and `ping` output correctly?
- Can you describe DNS resolution order and basic troubleshooting steps?

### Infrastructure Operations

- Can you isolate whether a failure is endpoint, route, firewall, DNS, or service level?
- Can you use packet capture to prove traffic is or is not leaving an interface?
- Can you document changes and verification commands with expected output?
- Can you recover from a bad firewall rule or routing change safely?

### Security Analyst

- Can you distinguish blocked traffic from an application error?
- Can you identify exposed ports and validate rule intent vs actual behavior?
- Can you triage a network issue from logs, packet traces, and host evidence?
- Can you articulate risk from misconfigured NAT, DNS, or firewall policies?

## Repository Workflow

Use version control as part of the learning process:

```bash
git status
git log --oneline --decorate --graph --all
```

Track your own notes, captured outputs, and remediation write-ups as additional commits.

## Validation Expectations

- Run each lab's `validation_script.sh`
- Compare outputs to the lab's validation checklist
- Practice the misconfiguration scenario before applying the full solution
- Use the troubleshooting tree before reading the solution

## Conventions

- Ubuntu-focused CLI examples (no GUI dependency)
- Real commands only (no pseudocode)
- Expected outputs included where practical
- Permission caveats documented (sudo, capabilities, bound ports)

## License / Usage

Internal training and self-study use. Adapt for team onboarding, but validate commands in your environment before production application.
