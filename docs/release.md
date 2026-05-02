# Release process

The release process for all packages in this monorepo (PSDocs, PSDocs.Azure,
VS Code extension) is documented in the repo-root [RELEASING.md][releasing]
runbook.

That runbook covers:

- One-time setup of GitHub Actions secrets and the `release` environment.
- Tag conventions per package (stable and preview).
- Step-by-step instructions for cutting a release.
- Pre-release flow for both PowerShell Gallery and VS Marketplace.
- Troubleshooting and rollback.

[releasing]: https://github.com/Azure/PSDocs.Azure/blob/main/RELEASING.md
