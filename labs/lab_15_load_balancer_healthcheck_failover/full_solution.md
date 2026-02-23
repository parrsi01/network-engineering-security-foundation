# Lab 15: HAProxy Load Balancer Health Check and Backend Failover - Full Solution

## Final Working Configuration

```bash
cp configs/sample_haproxy.cfg /tmp/lab15-haproxy/haproxy.cfg
nohup python3 -m http.server 9001 --bind 127.0.0.1 --directory /tmp/lab15-haproxy/site1 >/tmp/lab15-haproxy/b1.out 2>&1 &
nohup python3 -m http.server 9002 --bind 127.0.0.1 --directory /tmp/lab15-haproxy/site2 >/tmp/lab15-haproxy/b2.out 2>&1 &
sudo pkill haproxy || true
sudo haproxy -f /tmp/lab15-haproxy/haproxy.cfg -D -p /tmp/lab15-haproxy/haproxy.pid
sleep 1
curl -s http://127.0.0.1:8088
```

## Verification Commands

```bash
command -v haproxy >/dev/null 2>&1
test -f /tmp/lab15-haproxy/haproxy.cfg
ss -tulpn | grep -q ":8088"
curl -s --max-time 2 http://127.0.0.1:8088 | grep -Eq "backend-1|backend-2"
```

## Validation Checklist

- [ ] HAProxy binary available
- [ ] Lab config file exists
- [ ] Frontend listener up
- [ ] Load balancer responds
- [ ] `labs/lab_15_load_balancer_healthcheck_failover/validation_script.sh` returns `RESULT: PASS`
- [ ] Misconfiguration scenario reproduced and remediated
- [ ] Operational failure simulation triaged using evidence

## Cleanup (Optional)

```bash
# Optional cleanup: pkill haproxy; pkill -f "http.server 9001"; pkill -f "http.server 9002"; rm -rf /tmp/lab15-haproxy
```
