# FuseForge skill stability

[`skills/stability.json`](../../skills/stability.json) records which interfaces
have experimental behavior and which remain Skeleton-only.

## Experimental

Experimental entries are implemented and checked, but may change while the
coordinator contract is validated. User-visible changes require an updated
slice artifact and evidence.

## Skeleton

Skeleton entries express an approved interface only. They must not be described
as runnable or supported.

## Maintenance rules

- every listed path must exist exactly once in the registry;
- moving canonical policy requires all harness and verification references to
  change together;
- a Skeleton entry moves to implemented only through an approved slice;
- evidence maturity and package version remain separate concerns;
- `stable` must not be claimed before compatibility and migration policy are
  defined.
