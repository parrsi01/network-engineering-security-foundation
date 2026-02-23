# Lab 01: Linux Network Basics and Host Stack Visibility - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Restore and validate final lab state
sudo ip link set veth-l01 up
sudo ip netns exec lab01-peer ip link set veth-l01p up
sudo ip netns exec lab01-peer python3 -m http.server 8080 >/tmp/lab01/http.log 2>&1 &
ping -c 2 10.1.1.2
curl -sI http://10.1.1.2:8080 | head -5
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
sudo ip netns list | grep -q "^lab01-peer\b"
ip -o -4 addr show dev veth-l01 | grep -q "10.1.1.1/24"
ping -c 1 -W 1 10.1.1.2 >/dev/null 2>&1
curl -sI --max-time 2 http://10.1.1.2:8080 | grep -q "HTTP/1"
```

## Validation Checklist

- [ ] Namespace exists
- [ ] Host veth has expected IP
- [ ] Peer reachable
- [ ] HTTP 8080 reachable
- [ ] `labs/lab_01_linux_network_basics/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup
# sudo pkill -f 'python3 -m http.server 8080' || true
# sudo ip link del veth-l01 || true
# sudo ip netns del lab01-peer || true
```
