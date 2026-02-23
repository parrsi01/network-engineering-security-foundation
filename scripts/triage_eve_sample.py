#!/usr/bin/env python3
import collections
import json
import sys
from pathlib import Path


def read_eve_alerts(path: Path):
    alerts = []
    for line in path.read_text().splitlines():
        if not line.strip():
            continue
        obj = json.loads(line)
        if obj.get("event_type") != "alert":
            continue
        alerts.append(obj)
    return alerts


def read_tsv(path: Path):
    rows = []
    lines = path.read_text().splitlines()
    if not lines:
        return rows
    header = lines[0].split("\t")
    for line in lines[1:]:
        if not line.strip():
            continue
        vals = line.split("\t")
        rows.append(dict(zip(header, vals)))
    return rows


def main(argv):
    if len(argv) != 4:
        print("Usage: triage_eve_sample.py <eve.jsonl> <conn.tsv> <dns.tsv>", file=sys.stderr)
        return 1
    eve_path, conn_path, dns_path = map(Path, argv[1:])
    alerts = read_eve_alerts(eve_path)
    conn = read_tsv(conn_path)
    dns = read_tsv(dns_path)

    by_sig = collections.Counter(a.get("alert", {}).get("signature", "<no-signature>") for a in alerts)
    by_src = collections.Counter(a.get("src_ip", "<no-src>") for a in alerts)
    alert_pairs = {(a.get("src_ip"), str(a.get("src_port", "")), a.get("dest_ip"), str(a.get("dest_port", ""))) for a in alerts}
    matched_conn = [r for r in conn if (r.get("id.orig_h"), r.get("id.orig_p"), r.get("id.resp_h"), r.get("id.resp_p")) in alert_pairs]
    alert_srcs = {a.get("src_ip") for a in alerts}
    matched_dns = [r for r in dns if r.get("id.orig_h") in alert_srcs]

    print("Alert triage summary")
    print("===================")
    print(f"Total alerts: {len(alerts)}")
    print("Top signatures:")
    for sig, count in by_sig.most_common(5):
        print(f"- {count}x {sig}")
    print("Top alert sources:")
    for src, count in by_src.most_common(5):
        print(f"- {src}: {count}")
    print(f"Correlated conn rows: {len(matched_conn)}")
    for row in matched_conn[:5]:
        print(f"- conn {row.get('id.orig_h')}:{row.get('id.orig_p')} -> {row.get('id.resp_h')}:{row.get('id.resp_p')} state={row.get('conn_state')}")
    print(f"Correlated DNS rows: {len(matched_dns)}")
    for row in matched_dns[:5]:
        print(f"- dns {row.get('id.orig_h')} queried {row.get('query')} -> {row.get('answers')}")
    print("Disposition suggestion:")
    if by_sig and any("SCAN" in sig for sig in by_sig):
        print("- Repeated scan-like signatures observed; validate service exposure and source legitimacy before blocking.")
    else:
        print("- No repeated scan signatures observed in sample; continue host and packet correlation.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
