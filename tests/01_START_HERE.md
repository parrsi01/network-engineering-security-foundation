# Tests Start Here

## 1-x Order

1. Unit tests (Python) - `test_triage_eve_sample.py`

## Notes

Run tests from the repo root:

```bash
python3 -m unittest discover -s tests -p 'test_*.py' -v
```

`validate_repo.sh` and the GitHub `CI` workflow also run the unit tests.
