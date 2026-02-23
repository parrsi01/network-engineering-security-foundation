# Lab 10: VLAN Subinterfaces and Linux Bridge Segmentation - Objective

## Clear Technical Goal

Practice Linux bridge creation and 802.1Q VLAN subinterface troubleshooting using namespaces and a tagged trunk veth pair.

## Skills Trained

- linux bridge operations
- 802.1Q subinterfaces
- tcpdump vlan capture
- tag mismatch debugging

## Operational Relevance

VLAN/tagging mistakes are common during trunk migrations, virtualization host changes, and lab switch simulations.

## Lab Topology / Scope

Two namespaces connected by a veth trunk (`tr10a` <-> `tr10b`) with VLAN subinterfaces (`.10` and `.20`), plus a local Linux bridge on one side for bridge tooling practice.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS and CLI execution only.
- Many commands require `sudo` (namespaces, firewall, tcpdump, service binds).
- Use a disposable VM/snapshot before experimenting with firewall or control-plane changes.

## Deliverables

- Complete `labs/lab_10_vlan_bridge_segmentation/step_by_step_guide.md`
- Run `labs/lab_10_vlan_bridge_segmentation/validation_script.sh` and confirm `PASS`
- Document misconfiguration symptoms and recovery steps
