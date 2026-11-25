#!/usr/bin/env python3
"""Claimed-commit existence audit.
For every landing claim (a commit sha named in ACTIVITY.md / monitor logs /
lane reports), verify mechanically:
  1. the commit resolves on origin (gh api repos/<repo>/commits/<sha>)
  2. if the claim names a file, that file is in the commit's tree / file list
A claim whose commit does not resolve = NOT LANDED.
Usage: claimed_commit_audit.py <claims.json>  where claims.json is a list of
  {"sha": "...", "repo": "Daisuke134/anicca-ops", "file": "files/x.md" (optional), "source": "..."}
Prints one line per claim + a summary; exit 1 if any claim fails.
"""
import json, subprocess, sys

def gh(path):
    p = subprocess.run(['gh','api',path], capture_output=True, text=True)
    if p.returncode != 0:
        return None
    return json.loads(p.stdout)

def main():
    claims = json.load(open(sys.argv[1]))
    ok = fail = 0
    failures = []
    for c in claims:
        sha, repo = c['sha'], c.get('repo','Daisuke134/anicca-ops')
        commit = gh(f"repos/{repo}/commits/{sha}")
        if commit is None:
            fail += 1; failures.append({**c,'verdict':'NOT LANDED - commit does not resolve on origin'})
            print(f"FAIL {sha} ({repo}) file={c.get('file','-')} :: commit does not resolve :: {c.get('source','')}")
            continue
        f = c.get('file')
        if f:
            files = [x['filename'] for x in commit.get('files',[])]
            tree_hit = f in files
            if not tree_hit:
                # file may have landed in a different commit; check existence at that commit ref
                exists = gh(f"repos/{repo}/contents/{f}?ref={commit['sha']}")
                tree_hit = exists is not None
            if not tree_hit:
                fail += 1; failures.append({**c,'verdict':'COMMIT EXISTS but named file not in tree'})
                print(f"FAIL {sha} ({repo}) file={f} :: commit exists, named file NOT in its tree :: {c.get('source','')}")
                continue
        ok += 1
        print(f"OK   {sha} ({repo}) file={c.get('file','-')}")
    print(f"\nSUMMARY: checked={len(claims)} ok={ok} failed={fail}")
    json.dump(failures, open('/tmp/audit-failures.json','w'), indent=1)
    sys.exit(1 if fail else 0)

if __name__ == '__main__':
    main()
