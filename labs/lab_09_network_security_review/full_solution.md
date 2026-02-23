# Lab 09: Network Security Review and Exposure Assessment - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Example remediation actions
pkill -f 'python3 -m http.server 8090' || true
pkill -f 'nc -lk -p 9090' || true
ss -tulpn | grep -E ':8090|:9090' || true
echo 'Temporary listeners removed. Apply persistent firewall review checklist for production systems.'
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
command -v ss >/dev/null 2>&1
test -f /tmp/lab09/exposure_review.txt
grep -q "Action recommendation" /tmp/lab09/exposure_review.txt
command -v iptables >/dev/null 2>&1
```

## Validation Checklist

- [ ] `ss` command available
- [ ] Review report created
- [ ] Report contains Action recommendation
- [ ] iptables command available
- [ ] `labs/lab_09_network_security_review/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: pkill temporary listeners; remove `/tmp/lab09` directory.
```
