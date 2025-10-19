#!/usr/bin/env python3
"""
Usage:
  GITHUB_TOKEN=<token> python3 set_repo_secret.py MI804-png/webprogramming_with_lilla SSH_HOST "your.ssh.host.or.ip"
Or:
  python3 set_repo_secret.py <repo> <secret_name> <secret_value> <token>
"""
import sys, os, json, base64
import requests
from nacl import public

def get_public_key(repo, token):
    url = f"https://api.github.com/repos/{repo}/actions/secrets/public-key"
    headers = {"Authorization": f"token {token}", "Accept": "application/vnd.github+json"}
    r = requests.get(url, headers=headers)
    r.raise_for_status()
    data = r.json()
    return data["key"], data["key_id"]

def encrypt_secret(public_key_b64, secret_value):
    pk = public.PublicKey(base64.b64decode(public_key_b64))
    sealed_box = public.SealedBox(pk)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return base64.b64encode(encrypted).decode("utf-8")

def put_secret(repo, secret_name, encrypted_value, key_id, token):
    url = f"https://api.github.com/repos/{repo}/actions/secrets/{secret_name}"
    headers = {"Authorization": f"token {token}", "Accept": "application/vnd.github+json"}
    payload = {"encrypted_value": encrypted_value, "key_id": key_id}
    r = requests.put(url, headers=headers, data=json.dumps(payload))
    r.raise_for_status()
    return r.status_code

def main():
    if len(sys.argv) not in (4,5):
        print("Usage: GITHUB_TOKEN=<token> python3 set_repo_secret.py <owner/repo> <SECRET_NAME> <SECRET_VALUE>")
        print("Or: python3 set_repo_secret.py <owner/repo> <SECRET_NAME> <SECRET_VALUE> <token>")
        sys.exit(1)

    repo = sys.argv[1]
    secret_name = sys.argv[2]
    secret_value = sys.argv[3]
    token = os.environ.get("GITHUB_TOKEN") if len(sys.argv) == 4 else sys.argv[4]

    key, key_id = get_public_key(repo, token)
    encrypted_value = encrypt_secret(key, secret_value)
    put_secret(repo, secret_name, encrypted_value, key_id, token)
    print(f"Secret {secret_name} set on {repo}")

if __name__ == "__main__":
    main()
