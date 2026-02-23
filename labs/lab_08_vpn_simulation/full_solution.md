# Lab 08: WireGuard VPN Simulation (Conceptual + Linux Configuration Validation) - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Final reference config (replace placeholder keys before use)
cat /tmp/lab08/wg0.conf
echo 'Replace placeholder keys, then bring up interface with: sudo wg-quick up /tmp/lab08/wg0.conf (or move to /etc/wireguard/wg0.conf).'
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
command -v wg >/dev/null 2>&1
test -f /tmp/lab08/wg0.conf
grep -q "^\[Interface\]" /tmp/lab08/wg0.conf
grep -q "^AllowedIPs = " /tmp/lab08/wg0.conf
```

## Validation Checklist

- [ ] wireguard-tools installed
- [ ] Config file exists
- [ ] Config contains Interface section
- [ ] Config contains AllowedIPs
- [ ] `labs/lab_08_vpn_simulation/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: rm -rf /tmp/lab08 (ensure no real keys are needed first).
```
