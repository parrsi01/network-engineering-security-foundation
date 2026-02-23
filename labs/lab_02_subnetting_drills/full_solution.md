# Lab 02: Subnetting Drills with Reachability Consequences - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Final correct state: same /24 on both hosts
sudo ip netns exec l2a ip addr flush dev veth-l02a-ns
sudo ip netns exec l2b ip addr flush dev veth-l02b-ns
sudo ip netns exec l2a ip addr add 192.168.50.10/24 dev veth-l02a-ns
sudo ip netns exec l2b ip addr add 192.168.50.20/24 dev veth-l02b-ns
sudo ip netns exec l2a ping -c 2 192.168.50.20
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
sudo ip netns list | grep -q "^l2a\b" && sudo ip netns list | grep -q "^l2b\b"
ip link show br-l02 >/dev/null 2>&1
sudo ip netns exec l2a ip -o -4 addr show dev veth-l02a-ns | grep -q "192.168.50.10/24"
sudo ip netns exec l2a ping -c 1 -W 1 192.168.50.20 >/dev/null 2>&1
```

## Validation Checklist

- [ ] Namespaces l2a/l2b exist
- [ ] Bridge br-l02 exists
- [ ] l2a has /24 address
- [ ] l2b reachable from l2a
- [ ] `labs/lab_02_subnetting_drills/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: sudo ip link del br-l02; sudo ip netns del l2a; sudo ip netns del l2b
```
