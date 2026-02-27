---
applyTo: "**/assets/.env*,**/*repo*.dart,lib/pangea/common/network/**"
---

# Cross-Service Debugging (client)

See the [org-wide cross-service debugging guide](../../../.github/instructions/cross-service-debugging.instructions.md) for staging auth tokens, curl commands, local full-stack setup, and common pitfalls.

## Client-Specific Notes

- Staging `.env` config: set choreo and Matrix URLs to staging endpoints
- Local choreo testing: use `.env.local_choreo` to point at `localhost:8000`
- API repo files (e.g., `igc_repo.dart`) pair with request/response models — debug at the repo boundary
- Client calls choreo pre-send (grammar check, tokenization) and post-receive (reading assistance)
