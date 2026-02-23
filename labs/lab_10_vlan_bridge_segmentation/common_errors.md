# Lab 10: VLAN Subinterfaces and Linux Bridge Segmentation - Common Errors

## Real-World Errors and Resolutions

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `Ping fails for only one VLAN subnet` | VLAN ID mismatch on one trunk side | Compare `ip -d link show type vlan` outputs and correct the wrong VLAN ID. |
| ``RTNETLINK answers: File exists` creating `br-l10`` | Bridge already created from previous run | Reuse the existing bridge or delete it before rerunning setup. |
| `No VLAN tags visible in capture` | Capturing on VLAN subinterface instead of parent trunk | Capture on `tr10a`/`tr10b` parent interface with `-e vlan` display. |

## Notes

- Capture evidence before changing multiple variables at once.
- When using namespaces, confirm the namespace prefix in every command.
- Re-run validation after remediation to prove final state.
