---
applyTo: "**/.github/workflows/**,**/deploy*"
---

# Deployment (client)

Follows the [org-wide deployment conventions](../../../.github/instructions/deployment.instructions.md) — see that doc for pipelines, environment URLs, deploy notes, and coordination. This doc covers client-specific details only.

## Deploy Mechanism

- Flutter web build → S3 upload via GitHub Actions
- Mobile builds: manual app store builds and releases
- Staging: app.staging.pangea.chat (S3 + CloudFront)
- Production: app.pangea.chat (S3 + CloudFront)
