# Lab 15: HAProxy Load Balancer Health Check and Backend Failover - Common Errors

## Real-World Errors and Resolutions

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``haproxy: command not found`` | Package not installed | Install `haproxy` with apt before running the lab. |
| `Frontend listener missing on 8088` | HAProxy failed to start or config invalid | Run `haproxy -c` and inspect process status/output. |
| `LB returns timeouts after backend crash` | All backends down or wrong backend ports configured | Check backend listeners and restore `sample_haproxy.cfg` then restart HAProxy. |

## Notes

- Capture evidence before changing multiple variables at once.
- When using namespaces, confirm the namespace prefix in every command.
- Re-run validation after remediation to prove final state.
