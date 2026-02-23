# Lab 15: HAProxy Load Balancer Health Check and Backend Failover - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_15_load_balancer_healthcheck_failover`
- Validation script: `labs/lab_15_load_balancer_healthcheck_failover/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions
- Required tools/packages for this lab (see commands below)

## Setup Commands (Exact)

```bash
sudo apt install -y haproxy >/dev/null
mkdir -p /tmp/lab15-haproxy/site1 /tmp/lab15-haproxy/site2
echo 'backend-1' > /tmp/lab15-haproxy/site1/index.html
echo 'backend-2' > /tmp/lab15-haproxy/site2/index.html
nohup python3 -m http.server 9001 --bind 127.0.0.1 --directory /tmp/lab15-haproxy/site1 >/tmp/lab15-haproxy/b1.out 2>&1 &
nohup python3 -m http.server 9002 --bind 127.0.0.1 --directory /tmp/lab15-haproxy/site2 >/tmp/lab15-haproxy/b2.out 2>&1 &
cp configs/sample_haproxy.cfg /tmp/lab15-haproxy/haproxy.cfg
sudo pkill haproxy || true
sudo haproxy -f /tmp/lab15-haproxy/haproxy.cfg -D -p /tmp/lab15-haproxy/haproxy.pid
sleep 1
```

## Execution Steps

### Step 1: Validate HAProxy config and frontend listener

**Exact commands**

```bash
sudo haproxy -c -f /tmp/lab15-haproxy/haproxy.cfg
ss -tulpn | grep ':8088'
```

**Expected terminal output**

- HAProxy config validates successfully and a listener is present on `127.0.0.1:8088`.

**What is happening internally (network stack perspective)**

The frontend listener accepts client TCP connections and proxies them to healthy backend servers selected by HAProxy policy.

### Step 2: Test requests through the load balancer

**Exact commands**

```bash
for i in 1 2 3 4; do curl -s http://127.0.0.1:8088; done
```

**Expected terminal output**

- Responses show `backend-1` and/or `backend-2` depending on balancing and health-check timing.

**What is happening internally (network stack perspective)**

HAProxy performs health checks and only forwards client requests to backends considered UP.

### Step 3: Simulate backend failure and confirm failover

**Exact commands**

```bash
pkill -f 'http.server 9001' || true
sleep 2
for i in 1 2 3; do curl -s --max-time 2 http://127.0.0.1:8088; done
ss -tulpn | grep ':9001\|:9002' || true
```

**Expected terminal output**

- Frontend still serves responses from the surviving backend (`backend-2`) while port `9001` listener is absent.

**What is happening internally (network stack perspective)**

Health checks remove failed backends from the pool, preventing client-visible hard failures when at least one backend remains healthy.

## Intentional Misconfiguration Scenario (Required)

Change one backend port in HAProxy config to a wrong value and re-validate.

```bash
sed -i 's/server b2 127.0.0.1:9002/server b2 127.0.0.1:9999/' /tmp/lab15-haproxy/haproxy.cfg
sudo haproxy -c -f /tmp/lab15-haproxy/haproxy.cfg || true
grep -n 'server b2' /tmp/lab15-haproxy/haproxy.cfg
```

Expected outcome:

- Config may still parse, but backend health checks fail at runtime because the port is wrong.

## Real-World Operational Failure Simulation (Required)

A backend service crash during a deployment causes health-check failures and partial capacity loss; responders must confirm LB still serves traffic and identify the failing backend.

```bash
pkill -f 'http.server 9002' || true
sleep 2
curl -s --max-time 2 http://127.0.0.1:8088 || true
ss -tulpn | grep ':9001\|:9002' || true
sudo tail -n 30 /var/log/haproxy.log 2>/dev/null || true
```

## Debugging Walkthrough (Required)

1. Validate HAProxy syntax and frontend listener before checking application code.
2. Check backend listeners on `9001` and `9002` separately.
3. Recreate/restart failed backend, then re-test through the frontend and document recovery.

## Permission / Safety Notes

- `sudo` is required for namespaces, packet capture, and firewall changes.
- Stop test services after the lab to avoid unexpected local port conflicts.
- If running remotely, do not apply host firewall changes outside namespaces without recovery access.
