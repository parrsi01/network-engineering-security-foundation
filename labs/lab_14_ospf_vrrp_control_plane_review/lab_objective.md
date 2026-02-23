# Lab 14: OSPF (FRR) and VRRP (Keepalived) Control-Plane Review + VIP Failover Simulation - Objective

## Clear Technical Goal

Validate OSPF/VRRP configuration patterns and simulate VRRP-style VIP failover in namespaces while practicing control-plane troubleshooting checks.

## Skills Trained

- FRR OSPF config review
- Keepalived/VRRP config review
- VIP failover simulation
- control-plane packet troubleshooting

## Operational Relevance

Advanced infrastructure teams often troubleshoot redundancy and routing control planes even when the data-plane symptoms look like simple outages.

## Lab Topology / Scope

Two router namespaces (`vrrp14-a`, `vrrp14-b`) and one client namespace on a shared bridge; manual VIP move simulates VRRP failover. OSPF is handled as config + optional FRR checks.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS and CLI execution only.
- Many commands require `sudo` (namespaces, firewall, tcpdump, service binds).
- Use a disposable VM/snapshot before experimenting with firewall or control-plane changes.

## Deliverables

- Complete `labs/lab_14_ospf_vrrp_control_plane_review/step_by_step_guide.md`
- Run `labs/lab_14_ospf_vrrp_control_plane_review/validation_script.sh` and confirm `PASS`
- Document misconfiguration symptoms and recovery steps
