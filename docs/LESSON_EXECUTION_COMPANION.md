# Lesson Execution Companion

Author: Simon Parris  
Date: 2026-02-26

This companion is designed for slow, disciplined lab execution with clear evidence capture and minimal guessing.

## How To Use This Companion

Use this checklist during each lab and incident drill. Do not skip the evidence steps, even if you think you know the answer.

## Execution Checklist (Per Lab)

1. Read `lab_objective.md` and restate the goal in one sentence.
2. Review prerequisites and install commands in `step_by_step_guide.md`.
3. Predict what should happen before running commands.
4. Run commands exactly and compare outputs to the expected output sections.
5. Save key outputs for later review (screenshots or markdown notes).
6. Run the intentional misconfiguration scenario.
7. Use `troubleshooting_tree.md` before reading `full_solution.md`.
8. Run `validation_script.sh` and record the result.
9. Write a short "what failed / what fixed it / what I learned" summary.

## Evidence Prompts (Use These)

- What is the first observable symptom?
- Which layer is failing (L2/L3/DNS/firewall/service)?
- What command disproves my current assumption?
- What changed immediately before the failure?
- What is the rollback command if the next step makes it worse?

## Stop Conditions

Pause and recover safely if:

- you lose SSH/remote access
- firewall rules are blocking your management path
- routing changes affect unrelated lab traffic
- you are about to persist a config you do not understand

## Mobile-First Note Template

Copy this into your notes for each lab:

```text
Lab:
Objective:
Symptom:
Evidence Collected:
Root Cause:
Fix:
Validation Result:
Lessons Learned:
```
