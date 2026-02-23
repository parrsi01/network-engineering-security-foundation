import io
import sys
import unittest
from contextlib import redirect_stdout
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO_ROOT / "scripts"))

import triage_eve_sample  # noqa: E402


class TriageEveSampleTests(unittest.TestCase):
    def setUp(self):
        self.samples = REPO_ROOT / "labs" / "lab_13_security_monitoring_alert_triage" / "samples"
        self.eve = self.samples / "eve_sample.jsonl"
        self.conn = self.samples / "conn_sample.tsv"
        self.dns = self.samples / "dns_sample.tsv"

    def test_read_eve_alerts_filters_non_alert_events(self):
        alerts = triage_eve_sample.read_eve_alerts(self.eve)
        self.assertEqual(len(alerts), 3)
        self.assertTrue(all(a.get("event_type") == "alert" for a in alerts))

    def test_read_tsv_parses_rows(self):
        rows = triage_eve_sample.read_tsv(self.conn)
        self.assertGreaterEqual(len(rows), 1)
        self.assertIn("id.orig_h", rows[0])
        self.assertIn("id.resp_p", rows[0])

    def test_main_returns_usage_error_on_missing_args(self):
        rc = triage_eve_sample.main(["triage_eve_sample.py"])
        self.assertEqual(rc, 1)

    def test_main_generates_expected_summary(self):
        buf = io.StringIO()
        with redirect_stdout(buf):
            rc = triage_eve_sample.main(
                ["triage_eve_sample.py", str(self.eve), str(self.conn), str(self.dns)]
            )
        out = buf.getvalue()
        self.assertEqual(rc, 0)
        self.assertIn("Alert triage summary", out)
        self.assertIn("Total alerts: 3", out)
        self.assertIn("Correlated conn rows: 3", out)
        self.assertIn("Correlated DNS rows: 1", out)
        self.assertIn("Repeated scan-like signatures observed", out)


if __name__ == "__main__":
    unittest.main()
