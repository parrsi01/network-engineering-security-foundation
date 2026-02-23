# Lab 03: Routing Simulation with Linux Namespaces - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Final working configuration
sudo ip netns exec r3-router sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec r3-client ip route replace default via 10.10.30.1
sudo ip netns exec r3-server ip route replace default via 10.20.30.1
sudo ip netns exec r3-client ping -c 2 10.20.30.10
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
sudo ip netns list | grep -q "^r3-client\b" && sudo ip netns list | grep -q "^r3-router\b" && sudo ip netns list | grep -q "^r3-server\b"
sudo ip netns exec r3-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"
sudo ip netns exec r3-client ping -c 1 -W 1 10.20.30.10 >/dev/null 2>&1
sudo ip netns exec r3-server ip route show | grep -q "default via 10.20.30.1"
```

## Validation Checklist

- [ ] Namespaces exist
- [ ] Router IP forwarding enabled
- [ ] Client reaches server
- [ ] Server has default route
- [ ] `labs/lab_03_routing_simulation/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: sudo ip netns del r3-client; sudo ip netns del r3-router; sudo ip netns del r3-server
```
