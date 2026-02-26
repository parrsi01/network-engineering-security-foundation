# Core Concepts

Author: Simon Parris  
Date: 2026-02-26

This document summarizes the core engineering concepts reinforced across the network foundation labs, incidents, and troubleshooting drills.

## 1. Evidence-First Troubleshooting

- Start with observed symptoms, not assumptions.
- Collect host, route, DNS, firewall, and service evidence in layers.
- Record exact commands used and their outputs before changing state.

## 2. Packet Path Reasoning

Across the curriculum, you should be able to explain the full path of a packet:

1. Source interface/IP configuration
2. L2 reachability (ARP/MAC/VLAN)
3. L3 route selection/default gateway
4. NAT/firewall policy translation or filtering
5. DNS/service dependency resolution
6. Destination service listener and return path

## 3. Reproducibility

- Labs use fixed filenames and repeatable validation scripts.
- Misconfiguration scenarios are intentional and documented.
- Troubleshooting trees exist to train safe recovery under pressure.

## 4. Operational Safety

- Firewall/routing changes can remove remote access.
- Snapshot VMs before stateful networking changes.
- Prefer isolated VMs/namespaces/lab topologies over production hosts.

## 5. Security Mindset

- Network functionality is not sufficient without policy validation.
- Validate exposed ports, segmentation boundaries, and logging visibility.
- Compare intended rule behavior to actual observed packet flow.

## 6. Documentation Standard

Every lab is expected to produce:

- objective clarity
- exact setup commands
- expected output examples
- misconfiguration and failure simulation
- troubleshooting walkthrough
- validation evidence
