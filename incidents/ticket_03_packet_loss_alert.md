# Ticket 03: Packet Loss Alert - Client Complaints of Intermittent Timeouts

## Ticket Metadata

- Ticket ID: `NET-003`
- Severity: `SEV-3`
- Queue: `Network Operations`
- Reported By: `Synthetic latency/loss alert`
- Environment: `Namespace-based routed lab topology`

## Summary

Monitoring reports packet loss and elevated latency between a client subnet and an internal service subnet. Users report intermittent page loads and occasional retries succeeding.

## Symptoms Reported

- `ping` shows 10-30% packet loss during the incident window
- TCP sessions show retries/timeouts but recover intermittently
- No planned maintenance was announced

## Initial Evidence (Example)

```bash
sudo ip netns exec r3-client ping -c 20 10.20.30.10
# 20 packets transmitted, 15 received, 25% packet loss

sudo ip netns exec r3-router tc qdisc show
# qdisc netem ... loss 20% ...
```

## Expected Responder Workflow

1. Validate whether loss is local interface, router, or downstream using hop-by-hop tests
2. Inspect `tc qdisc` state for accidental netem simulation left enabled
3. Capture traffic (`tcpdump`) and correlate with retransmissions/timeouts
4. Remove simulation/qdisc and confirm recovery

## Root Cause Pattern (For Instructor Use)

A netem packet loss simulation remained applied to a router interface after testing, causing synthetic but realistic packet loss.

## Resolution Acceptance Criteria

- Packet loss returns to 0% (or expected baseline)
- `tc qdisc show` confirms netem removed from affected interface
- Before/after evidence attached to ticket notes
