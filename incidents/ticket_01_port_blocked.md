# Ticket 01: Port Blocked - Internal Web Service Unreachable

## Ticket Metadata

- Ticket ID: `NET-001`
- Severity: `SEV-2`
- Queue: `Infrastructure Operations`
- Reported By: `Application Team`
- Environment: `Ubuntu lab router/firewall namespace`

## Summary

Users on the client subnet cannot access the internal web service on TCP/8080. The application owner reports the service is running and healthy on the server host.

## Symptoms Reported

- `curl http://10.20.40.10:8080` times out from the client segment
- Ping to the server IP may still succeed
- Incident started after a firewall rule cleanup

## Known Facts / Constraints

- No switch changes were made
- Server process restart does not restore access
- The issue likely originated during a firewall change window

## Initial Evidence (Example)

```bash
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080
# curl: (28) Operation timed out after 3001 milliseconds with 0 bytes received

sudo ip netns exec fw-client ping -c 2 10.20.40.10
# 2 packets transmitted, 2 received
```

## Expected Responder Workflow

1. Prove service listener state on server namespace (`ss -tulpn`)
2. Inspect router namespace `FORWARD` chain with counters and rule order
3. Validate presence of `ESTABLISHED,RELATED` rule
4. Re-test and capture evidence of restored traffic

## Root Cause Pattern (For Instructor Use)

A `DROP` rule was inserted above the allow rule or the `ESTABLISHED,RELATED` rule was removed, breaking TCP return traffic.

## Resolution Acceptance Criteria

- HTTP request from client to server succeeds with `200 OK`
- Firewall rule counters reflect expected matches
- Final rule set documented in incident notes
