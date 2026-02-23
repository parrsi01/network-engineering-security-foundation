# Lab 12: Segmented Multi-Subnet Services and Policy Enforcement - Common Errors

## Real-World Errors and Resolutions

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `Client can access DB unexpectedly` | Overly broad allow rule inserted in FORWARD chain | Inspect line-numbered rules and remove accidental client->DB allow entries. |
| `Allowed app path fails after firewall change` | Missing `ESTABLISHED,RELATED` rule | Restore stateful return-traffic rule near the top of the chain. |
| ``curl` fails but router rules look correct` | App service not listening/bound | Check `ss -tulpn` in `s12-app` namespace and restart the HTTP service. |

## Notes

- Capture evidence before changing multiple variables at once.
- When using namespaces, confirm the namespace prefix in every command.
- Re-run validation after remediation to prove final state.
