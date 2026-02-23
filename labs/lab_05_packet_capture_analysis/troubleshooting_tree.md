# Lab 05: Packet Capture Analysis with tcpdump - Troubleshooting Tree

## Decision Tree Logic

If capture shows nothing -> verify correct interface and generate traffic during capture window.
If ping works but HTTP capture shows SYN retransmits only -> check server listener on port 8080.
If handshake completes but app still fails -> inspect HTTP payload/status and server logs.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
