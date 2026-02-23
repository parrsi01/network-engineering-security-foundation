# Lab 10: VLAN Subinterfaces and Linux Bridge Segmentation - Full Solution

## Final Working Configuration

```bash
sudo ip netns exec vlan10-b ip link del tr10b.20
sudo ip netns exec vlan10-b ip link add link tr10b name tr10b.20 type vlan id 20
sudo ip netns exec vlan10-b ip addr add 10.10.20.2/24 dev tr10b.20
sudo ip netns exec vlan10-b ip link set tr10b.20 up
sudo ip netns exec vlan10-a ping -c 2 10.10.20.2
```

## Verification Commands

```bash
sudo ip netns list | grep -q "^vlan10-a\b" && sudo ip netns list | grep -q "^vlan10-b\b"
sudo ip netns exec vlan10-a ip -d link show tr10a.10 | grep -q "vlan id 10"
sudo ip netns exec vlan10-a ping -c 1 -W 1 10.10.20.2 >/dev/null 2>&1
ip link show br-l10 >/dev/null 2>&1
```

## Validation Checklist

- [ ] Namespaces exist
- [ ] VLAN 10 exists on side A
- [ ] VLAN 20 ping works
- [ ] Bridge br-l10 exists
- [ ] `labs/lab_10_vlan_bridge_segmentation/validation_script.sh` returns `RESULT: PASS`
- [ ] Misconfiguration scenario reproduced and remediated
- [ ] Operational failure simulation triaged using evidence

## Cleanup (Optional)

```bash
# Optional cleanup: sudo ip netns del vlan10-a; sudo ip netns del vlan10-b; sudo ip link del br-l10 || true
```
