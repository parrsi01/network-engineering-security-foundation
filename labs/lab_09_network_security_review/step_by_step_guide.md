# Lab 09: Network Security Review and Exposure Assessment - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_09_network_security_review`
- Validation script: `labs/lab_09_network_security_review/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
mkdir -p /tmp/lab09
nohup python3 -m http.server 8090 >/tmp/lab09/http8090.log 2>&1 &
nohup nc -lk -p 9090 >/tmp/lab09/nc9090.log 2>&1 &
sleep 1
```

## Execution Steps

### Step 1: Inventory listening services and bind addresses

**Exact commands**

```bash
ss -tulpn | grep -E ':8090|:9090|:22' || true
sudo lsof -iTCP -sTCP:LISTEN -P -n | grep -E ':8090|:9090|:22' || true
```

**Expected terminal output**

Expected output snippets:
- Processes listening on `:8090` and `:9090`
- Bind addresses (`0.0.0.0`, `127.0.0.1`, or specific interface IP)

**What is happening internally (network stack perspective)**

A listening socket is application-layer readiness; bind address determines which interfaces can receive packets before firewall policy is evaluated.

### Step 2: Audit local firewall and NAT posture

**Exact commands**

```bash
sudo iptables -L -n -v
sudo iptables -t nat -L -n -v
sudo ufw status verbose || true
```

**Expected terminal output**

Expected output snippets:
- Default policies and explicit allow/deny rules visible
- NAT table entries (if configured) visible with counters

**What is happening internally (network stack perspective)**

Firewall and NAT rules can expose or restrict services independently of whether the process is listening, so both must be reviewed together.

### Step 3: Document an evidence-based exposure summary

**Exact commands**

```bash
cat > /tmp/lab09/exposure_review.txt <<'REPORT'
Observed listeners:
- 8090/tcp (python http.server) - verify if temporary training service is intended
- 9090/tcp (nc listener) - high risk if left exposed, no auth

Firewall review:
- Record default policies and matching allow rules from iptables/UFW output

Action recommendation:
- Stop temporary listeners or restrict source IPs
REPORT
cat /tmp/lab09/exposure_review.txt
```

**Expected terminal output**

Expected output snippets:
- A concise review report listing listeners, firewall posture, and remediation actions

**What is happening internally (network stack perspective)**

Operational security reviews require converting command evidence into a risk-oriented summary that others can act on quickly.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: start a temporary service bound to all interfaces (`0.0.0.0`) instead of loopback-only.

```bash
ss -tulpn | grep ':9090' || true
echo 'If this listener is not intended externally, stop it or rebind to 127.0.0.1.'
```

Expected outcome:

- The listener appears exposed on all interfaces, increasing attack surface unnecessarily.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: firewall reset during troubleshooting leaves temporary ports exposed after a maintenance task.

```bash
echo 'Review `iptables -L -n -v` and `ufw status verbose` after any firewall reset or reload.'
echo 'Compare active listeners to approved service inventory before ending the change window.'
```

## Debugging Walkthrough (Required)

1. Inventory active listeners and note bind addresses.
2. Map listeners to firewall rules and intended business use.
3. Shut down or restrict temporary services, then re-verify exposure.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
