# Ticket 05: Latency Spike - Performance Degradation Without Full Outage

## Ticket Metadata

- Ticket ID: `NET-005`
- Severity: `SEV-3`
- Queue: `Infrastructure Operations`
- Reported By: `User Experience Monitoring`
- Environment: `Ubuntu VM lab host or namespace path`

## Summary

Application remains available, but response times increase sharply. Operations needs to determine whether the slowdown is network transport, DNS resolution, or application processing.

## Symptoms Reported

- Users can connect, but pages/services respond slowly
- RTT to gateway may be normal while end-to-end latency is elevated
- Intermittent spikes correspond to recent network testing activity

## Initial Evidence (Example)

```bash
ping -c 20 8.8.8.8
# rtt min/avg/max/mdev = 12.1/98.4/220.7/47.8 ms

tc qdisc show dev eth0
# qdisc netem ... delay 120ms 20ms distribution normal
```

## Expected Responder Workflow

1. Measure latency to gateway vs target service/IP
2. Check DNS lookup timing separately from transport timing
3. Inspect `tc qdisc` for leftover delay simulation (`netem`)
4. Remove qdisc, re-measure, and confirm recovery
5. Document impact window and recovery steps

## Root Cause Pattern (For Instructor Use)

Netem latency simulation remained configured on an interface after a training exercise, creating elevated RTT without a complete outage.

## Resolution Acceptance Criteria

- RTT returns near baseline after qdisc removal
- `tc qdisc show` shows no unintended netem delay
- Incident notes distinguish transport latency from application latency
