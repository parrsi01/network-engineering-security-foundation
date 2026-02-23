# Full Course CLI Demo Sheet

## Baseline Host Triage (5-minute sequence)

```bash
ip -br link
ip -br addr
ip route show
ip route get 8.8.8.8
getent hosts example.com
ss -tulpn
sudo iptables -L -n -v
sudo tcpdump -ni any -c 10 host 8.8.8.8
```

## Namespace Router Build Demo (Labs 03/04/07 Pattern)

```bash
sudo ip netns add demo-client
sudo ip netns add demo-router
sudo ip netns add demo-server
# Create veth pairs, assign IPs, set routes, enable forwarding
```

## Firewall Verification Demo

```bash
sudo ip netns exec fw-router iptables -L FORWARD -n -v --line-numbers
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080
```

## DNS Debugging Demo

```bash
sudo ip netns exec dns-client getent hosts lab6.test
sudo ip netns exec dns-client dig +short lab6.test
sudo ip netns exec dns-client dig @10.60.6.53 +short lab6.test
sudo tcpdump -ni br-l06 port 53 -c 20
```

## NAT Port Forward Validation Demo

```bash
sudo ip netns exec nat-router iptables -t nat -L -n -v
sudo ip netns exec nat-client curl -sI --max-time 3 http://10.10.70.1:8080
```
