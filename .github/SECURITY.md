# Security Policy

## Supported versions

Security fixes target the latest FuseForge release.

| Version | Supported |
|---|---|
| 0.1.x | Yes |

FuseForge is experimental and pre-1.0. There is no long-term support branch.

## Scope

FuseForge is a local skill and methodology pack, not a hosted service. Security
scope covers the setup scripts, repository checks, GitHub Actions workflows,
packaged agent instructions, and the coordination policy that tells an agent
which files it may create.

The following belong to their own projects: Claude Code, Codex CLI, Cursor
Agent, Compforge, OOPforge, and any framework or dependency chosen for a
generated product. Report those to the relevant vendor.

A coordination policy defect that could cause an agent to write outside an
approved work root, mutate an existing installation, or leak a local path into a
tracked artifact is in scope. Please report it here.

## Reporting a vulnerability

Use
[GitHub private vulnerability reporting](https://github.com/LooSung/fuseforge/security/advisories/new).
Do not open a public issue containing an exploit, a credential, or private
environment detail.

Include the affected FuseForge version or commit, the harness and its version,
reproduction steps, observed impact, and any proposed mitigation. Redact
absolute paths and account identifiers before pasting output.

This is a personal open-source project without a response-time SLA. Accepted
reports are fixed and disclosed through a GitHub Security Advisory and release
notes when appropriate.
