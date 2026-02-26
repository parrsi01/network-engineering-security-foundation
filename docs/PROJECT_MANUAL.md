# Project Manual

Author: Simon Parris  
Date: 2026-02-26

## Purpose

This repository is a structured training environment for developing job-ready network engineering and network security troubleshooting skills using reproducible labs, documentation, and validation workflows.

## Operating Model

- Read theory in `docs/` and `Library/`
- Execute labs in `labs/`
- Practice evidence collection and incident response in `incidents/`
- Validate changes and learning artifacts with `validate_repo.sh`
- Commit progress in small, topic-specific commits

## Suggested Weekly Workflow

1. Pick one topic track and one lab.
2. Read the corresponding docs section and quick references.
3. Execute the lab exactly as written.
4. Intentionally break the lab as described.
5. Recover using the troubleshooting tree before reading the full solution.
6. Capture your own notes, command output, and lessons learned.
7. Run validation and commit the result.

## Evidence Standard (What to Keep)

- command history snippets
- `ip addr`, `ip route`, `ss`, `ping`, `tcpdump` outputs where relevant
- firewall rules before/after changes
- DNS query results and packet captures for debugging labs
- short remediation summaries for incident drills

## Safety and Guardrails

- Use local VMs or disposable lab systems.
- Avoid applying firewall/routing/NAT commands on production or remote hosts without a console fallback.
- Snapshot before major changes.
- Document rollback steps before modifying persistent configs.

## Quality Gates

Before pushing changes:

1. Run `./validate_repo.sh --quick`
2. Run `python3 -m unittest discover -s tests -p 'test_*.py' -v`
3. Review diffs for accidental outputs/secrets/host-specific data

## Deliverables (Portfolio-Friendly)

- Completed lab notes and validated scripts
- Incident triage write-ups with evidence and root cause
- Clean repo history showing iterative troubleshooting and recovery
- CV-ready summaries and skill mappings in `docs/`
