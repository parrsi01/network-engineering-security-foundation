# Ticket 10: Load Balancer Backend Failure - Partial Capacity Loss

## Ticket Metadata

- Ticket ID: `NET-010`
- Severity: `SEV-2`
- Queue: `Infrastructure Operations`

## Summary

Frontend remains reachable, but response times increase and some requests fail after a deployment. Load balancer health checks show backend instability.

## Expected Workflow

1. Validate LB config syntax and frontend listener
2. Check backend health/listeners directly
3. Confirm health-check failures and failover behavior
4. Restore failed backend and verify traffic returns to baseline

## Root Cause Pattern (Instructor)

One backend service crashed or backend port changed, leaving HAProxy with reduced pool health.
