# Lab 05: Packet Capture Analysis with tcpdump - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Restore service and regenerate successful TCP capture
sudo ip netns exec cap-server python3 -m http.server 8080 >/tmp/cap-http.log 2>&1 &
sudo ip netns exec cap-client curl -s http://10.50.5.20:8080 >/dev/null
sudo tcpdump -ni br-l05 tcp port 8080 -c 10
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
ip link show br-l05 >/dev/null 2>&1
sudo ip netns exec cap-client ping -c 1 -W 1 10.50.5.20 >/dev/null 2>&1
test -d labs/lab_05_packet_capture_analysis/captures
sudo ip netns exec cap-client curl -s --max-time 2 http://10.50.5.20:8080 >/dev/null
```

## Validation Checklist

- [ ] Bridge exists
- [ ] Client reaches server via ping
- [ ] Capture directory exists
- [ ] HTTP service reachable
- [ ] `labs/lab_05_packet_capture_analysis/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: remove namespaces and bridge; delete `captures/*.pcap` if desired.
```
