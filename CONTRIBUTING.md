# Contributing to FluffyChat
Contributions are always welcome. Yet we might lack manpower to review all of them in time.

To improve the process please make sure that you read the following guidelines carefully:

## Contributing Guidelines

1. Always create a Pull Request for any changes.
2. Whenever possible please make sure that your Pull Request only contains **one** commit. Cases where multiple commits make sense are very rare.
3. Do not add merge commits. Use rebases.
4. Every Pull Request should change only one thing. For bigger changes it is often better to split them up in multiple Pull Requests.
5. [Sign your commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).
6. Format the commit message as [Conventional Commits](https://www.conventionalcommits.org).
7. Format (`flutter format lib`) and sort impots (`dart run import_sorter:main --no-comments`) in all code files.
8. For bigger or complex changes (more than a couple of code lines) write an issue or refer to an existing issue and ask for approval from the maintainers (@krille-chan) **before** starting to implement it. This way you reduce the risk that your Pull Request get's declined.
9. Prefer simple and easy to maintain solutions over complexity and fancy ones.