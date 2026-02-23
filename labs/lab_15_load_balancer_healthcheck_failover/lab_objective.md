# Lab 15: HAProxy Load Balancer Health Check and Backend Failover - Objective

## Clear Technical Goal

Run HAProxy locally with two backend servers, validate load-balancer behavior, and simulate backend failure and recovery.

## Skills Trained

- haproxy config validation
- frontend/backend testing
- health-check troubleshooting
- service failover verification

## Operational Relevance

Load-balancer outages often originate from backend health checks, listener binds, or firewall reachability rather than app code changes.

## Lab Topology / Scope

Single host lab: HAProxy frontend on `127.0.0.1:8088` with two local Python HTTP backends on `127.0.0.1:9001` and `127.0.0.1:9002`.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS and CLI execution only.
- Many commands require `sudo` (namespaces, firewall, tcpdump, service binds).
- Use a disposable VM/snapshot before experimenting with firewall or control-plane changes.

## Deliverables

- Complete `labs/lab_15_load_balancer_healthcheck_failover/step_by_step_guide.md`
- Run `labs/lab_15_load_balancer_healthcheck_failover/validation_script.sh` and confirm `PASS`
- Document misconfiguration symptoms and recovery steps
