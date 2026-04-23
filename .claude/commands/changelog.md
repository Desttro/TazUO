---
description: Draft a CHANGELOG entry from commits since the last tag
allowed-tools: Bash(git log *), Bash(git tag *), Bash(git describe *), Read
---

Draft a `CHANGELOG.md` entry for the unreleased work.

1. Find the last tag:
   ```bash
   git describe --tags --abbrev=0
   ```
2. List commits since that tag:
   ```bash
   git log <last-tag>..HEAD --pretty=format:"%h %s"
   ```
3. Read `CHANGELOG.md` to learn the existing style (section headings, grouping, voice).
4. Draft a new section matching that style — group commits into categories (e.g. Added / Changed / Fixed / Removed). Do not invent entries; base everything on actual commits.
5. **Do not** write to `CHANGELOG.md` yet. Show the proposed draft to the user for review.
