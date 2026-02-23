# Lab 11: DHCP Lease Debugging with dnsmasq and dhclient - Objective

## Clear Technical Goal

Run a lab DHCP server in a namespace, acquire leases with `dhclient`, and troubleshoot DORA failures using packet capture.

## Skills Trained

- dnsmasq DHCP setup
- dhclient troubleshooting
- UDP 67/68 packet capture
- lease failure isolation

## Operational Relevance

DHCP failures cause broad endpoint outages and are often confused with switch/VLAN problems during changes.

## Lab Topology / Scope

Two namespaces on a Linux bridge: `dhcp11-client` and `dhcp11-server` with `dnsmasq` serving leases on the server side.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS and CLI execution only.
- Many commands require `sudo` (namespaces, firewall, tcpdump, service binds).
- Use a disposable VM/snapshot before experimenting with firewall or control-plane changes.

## Deliverables

- Complete `labs/lab_11_dhcp_lease_debugging/step_by_step_guide.md`
- Run `labs/lab_11_dhcp_lease_debugging/validation_script.sh` and confirm `PASS`
- Document misconfiguration symptoms and recovery steps
