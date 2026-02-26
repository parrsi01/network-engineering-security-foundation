# Lesson Research & Analysis Companion

Author: Simon Parris  
Date: 2026-02-26

Use this companion when studying the theory behind each lab, writing reflective notes, or preparing for interviews.

## Analysis Framework (Per Topic)

For each docs topic (for example `docs/fundamentals/` or `docs/security_monitoring/`), capture:

1. Core definition (plain language)
2. Why it matters operationally
3. Common failure modes
4. Evidence sources (commands/logs/packets)
5. Verification commands
6. Security implications
7. Recovery / rollback considerations

## Interview Translation Prompts

- Explain this concept using a real troubleshooting scenario.
- What command output would prove the issue?
- What is the fastest safe rollback?
- What would you document in a production ticket after fixing it?

## Suggested Topic-to-Lab Mapping Notes

- Foundations topics -> Labs 01-03
- Troubleshooting topics -> Labs 04-08
- Security topics -> Lab 09 + incidents
- Segmentation topics -> Labs 10+
- Monitoring topics -> Suricata/Zeek labs + triage drills
- Advanced infrastructure topics -> OSPF/VRRP/LB labs

## Portfolio / CV Evidence You Can Extract

- subnetting and route-debugging accuracy
- packet capture interpretation
- firewall/NAT policy validation
- segmented network design and verification
- security monitoring triage workflows
- change control and rollback discipline
