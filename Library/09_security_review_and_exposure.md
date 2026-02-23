# 09 - Security Review and Exposure

## Quick Exposure Review Workflow

```bash
ss -tulpn
sudo iptables -L -n -v
sudo iptables -t nat -L -n -v
sudo ufw status verbose
```

## Review Questions

- Which services are listening, and on which bind addresses?
- Are they intentionally exposed?
- Do firewall and NAT rules match documented intent?
- Are temporary services still running after testing?

## Operational Security Insight

Most preventable network exposure incidents come from drift, temporary changes, or incomplete rollback rather than sophisticated attacks.
