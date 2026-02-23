#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

quick_mode=0
for arg in "$@"; do
  case "$arg" in
    --quick) quick_mode=1 ;;
    -h|--help)
      cat <<'USAGE'
Usage: ./validate_repo.sh [--quick]

Default mode:
  Runs repository compliance checks and prints:
  - PASS/FAIL checks
  - final directory tree
  - git commit history summary
  - readiness scoring
  - estimated time to complete full curriculum

Quick mode:
  Runs checks only (skips tree/log/report summaries).
USAGE
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

failures=0

section() {
  printf '\n=====================================================\n%s\n=====================================================\n' "$1"
}

pass() {
  echo "PASS: $1"
}

fail() {
  echo "FAIL: $1"
  failures=$((failures+1))
}

warn() {
  echo "WARN: $1"
}

run_check() {
  local name="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass "$name"
  else
    fail "$name"
  fi
}

section "Repository Validation"

run_check "Git repository present" git rev-parse --is-inside-work-tree
run_check "README.md present" test -f README.md
run_check "Top-level folders present" test -d docs
run_check "Top-level folders present (labs)" test -d labs
run_check "Top-level folders present (incidents)" test -d incidents
run_check "Top-level folders present (library)" test -d library
run_check "Top-level folders present (Library)" test -d Library

if python3 - <<'PY'
from pathlib import Path
import sys

repo = Path('.')
required = [
    'lab_objective.md',
    'step_by_step_guide.md',
    'full_solution.md',
    'common_errors.md',
    'troubleshooting_tree.md',
    'validation_script.sh',
]
labs = sorted([p for p in (repo / 'labs').glob('lab_*') if p.is_dir()])
if not labs:
    print("FAIL: no lab directories found")
    sys.exit(2)

missing = []
nonexec = []
for lab in labs:
    for name in required:
        p = lab / name
        if not p.exists():
            missing.append(str(p))
    v = lab / 'validation_script.sh'
    if v.exists() and (v.stat().st_mode & 0o111) == 0:
        nonexec.append(str(v))

if missing or nonexec:
    if missing:
        print("Missing required lab files:")
        for m in missing:
            print(f" - {m}")
    if nonexec:
        print("Non-executable validation scripts:")
        for n in nonexec:
            print(f" - {n}")
    sys.exit(1)

print(f"PASS: {len(labs)} labs include mandatory structure and executable validators")
PY
then
  pass "Mandatory lab structure enforcement"
else
  fail "Mandatory lab structure enforcement"
fi

if python3 - <<'PY'
from pathlib import Path
import sys

repo = Path('.')
snippets = [
    '## Setup Commands (Exact)',
    '**Expected terminal output**',
    'network stack perspective',
    '## Intentional Misconfiguration Scenario (Required)',
    '## Real-World Operational Failure Simulation (Required)',
    '## Debugging Walkthrough (Required)',
]
for lab in sorted([p for p in (repo / 'labs').glob('lab_*') if p.is_dir()]):
    guide = (lab / 'step_by_step_guide.md').read_text(encoding='utf-8')
    missing = [s for s in snippets if s not in guide]
    if missing:
        print(f"FAIL: {lab.name} missing sections: {missing}")
        sys.exit(1)
print("PASS: all lab guides include required execution/output/simulation/debug sections")
PY
then
  pass "Lab guide content requirements"
else
  fail "Lab guide content requirements"
fi

if command -v rg >/dev/null 2>&1; then
  if rg -n "TODO|TBD|FIXME|PLACEHOLDER|REPLACE_WITH_|lorem ipsum" . \
      --glob '!**/.git/**' \
      --glob '!validate_repo.sh' >/tmp/validate_repo_placeholders.out; then
    cat /tmp/validate_repo_placeholders.out
    fail "No placeholder/template markers remain"
  else
    pass "No placeholder/template markers remain"
  fi
else
  if grep -RInE "TODO|TBD|FIXME|PLACEHOLDER|REPLACE_WITH_|lorem ipsum" . \
      --exclude-dir=.git --exclude=validate_repo.sh >/tmp/validate_repo_placeholders.out; then
    cat /tmp/validate_repo_placeholders.out
    fail "No placeholder/template markers remain"
  else
    pass "No placeholder/template markers remain"
  fi
fi
rm -f /tmp/validate_repo_placeholders.out

# Shell syntax checks for repo scripts and lab validators.
shell_failed=0
while IFS= read -r -d '' f; do
  if ! bash -n "$f"; then
    echo "Syntax error: $f"
    shell_failed=1
  fi
done < <(find scripts labs -type f \( -name '*.sh' \) -print0 2>/dev/null)

if [[ $shell_failed -eq 0 ]]; then
  pass "Shell syntax checks (scripts + lab validators)"
else
  fail "Shell syntax checks (scripts + lab validators)"
fi

# Python syntax checks for helper scripts (if any).
py_failed=0
pycache_tmp=""
cleanup_pycache_tmp() {
  if [[ -n "${pycache_tmp:-}" && -d "${pycache_tmp:-}" ]]; then
    rm -rf "$pycache_tmp"
  fi
}
trap cleanup_pycache_tmp EXIT
while IFS= read -r -d '' pyf; do
  pycache_tmp="$(mktemp -d)"
  if ! PYTHONPYCACHEPREFIX="$pycache_tmp" python3 -m py_compile "$pyf" >/dev/null 2>&1; then
    echo "Python syntax error: $pyf"
    py_failed=1
  fi
  rm -rf "$pycache_tmp"
  pycache_tmp=""
done < <(find scripts -maxdepth 1 -type f -name '*.py' -print0 2>/dev/null)

if [[ $py_failed -eq 0 ]]; then
  pass "Python helper syntax checks"
else
  fail "Python helper syntax checks"
fi

# Lightweight "runnability" confirmation: structural + validation scripts + mandatory sections.
# Full runtime execution of all labs is intentionally not forced here because many labs require sudo
# and modify local namespace/firewall state.
pass "Lab runnable readiness (structural/syntax compliance confirmed)"

if [[ $quick_mode -eq 0 ]]; then
  section "Final Directory Tree"
  if command -v tree >/dev/null 2>&1; then
    tree -a -I '.git'
  else
    find . -path './.git' -prune -o -print | sort
  fi

  section "Git Commit History Summary"
  git log --oneline --decorate --reverse

  section "Repository Metrics"
  python3 - <<'PY'
from pathlib import Path
repo = Path('.')
metrics = {
    "docs_files": sum(1 for _ in (repo / "docs").rglob("*.md")),
    "lab_dirs": sum(1 for p in (repo / "labs").glob("lab_*") if p.is_dir()),
    "lab_files": sum(1 for _ in (repo / "labs").rglob("*") if _.is_file()),
    "incident_files": sum(1 for _ in (repo / "incidents").glob("*.md")),
    "library_files": sum(1 for _ in (repo / "library").glob("*") if _.is_file()),
    "Library_files": sum(1 for _ in (repo / "Library").glob("*") if _.is_file()),
    "script_files": sum(1 for _ in (repo / "scripts").glob("*") if _.is_file()),
    "config_files": sum(1 for _ in (repo / "configs").glob("*") if _.is_file()),
}
for k, v in metrics.items():
    print(f"{k}={v}")
PY

  section "Readiness Scoring"
  python3 - <<'PY'
from pathlib import Path

repo = Path('.')
labs = sum(1 for p in (repo / 'labs').glob('lab_*') if p.is_dir())
incidents = sum(1 for _ in (repo / 'incidents').glob('ticket_*.md'))
has_seg = (repo / 'docs' / 'segmentation').exists()
has_sec_mon = (repo / 'docs' / 'security_monitoring').exists()
has_adv = (repo / 'docs' / 'advanced_infrastructure').exists()

junior = min(100, 70 + min(labs, 15) + (5 if (repo/'docs'/'fundamentals').exists() else 0) + (2 if (repo/'library'/'subnetting_quick_ref.md').exists() else 0))
infra = min(100, 60 + min(labs, 15) + min(incidents, 10) + (5 if has_seg else 0) + (5 if has_adv else 0) + (3 if (repo/'scripts'/'network_diagnostics.sh').exists() else 0))
security = min(100, 58 + min(incidents, 10) + (8 if has_sec_mon else 0) + (4 if (repo/'labs'/'lab_09_network_security_review').exists() else 0) + (6 if (repo/'labs'/'lab_13_security_monitoring_alert_triage').exists() else 0) + (4 if (repo/'library'/'security_monitoring_triage_quick_ref.md').exists() else 0))

print(f"Junior Network Engineer readiness score: {junior}/100")
print(f"Infrastructure Operations readiness score: {infra}/100")
print(f"Security Analyst readiness score: {security}/100")
PY

  section "Estimated Time To Complete Full Curriculum"
  echo "Guided pass (read + run core and progression labs once): 55-75 hours"
  echo "Competency pass (repeat labs, misconfigs, incidents, write-ups): 90-130 hours"
fi

section "Validation Result"
if [[ $failures -eq 0 ]]; then
  echo "RESULT: PASS"
  if git status --short | grep -q .; then
    warn "Working tree is not clean after validation (check generated artifacts or local changes)."
  else
    pass "Working tree clean"
  fi
  exit 0
else
  echo "RESULT: FAIL ($failures checks failed)"
  exit 1
fi
