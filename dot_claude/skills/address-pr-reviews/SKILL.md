---
name: address-pr-reviews
description: Get PR reviews from GitHub, evaluate them, and fix valid issues
argument-hint: "[PR number or branch name]"
disable-model-invocation: true
---

## Context

You are reviewing feedback left on a GitHub Pull Request and acting on it.
Most review comments come from **Devin**, an AI reviewer bot. This means you should be
**extra critical** — bot reviews are often useful but can also be noisy, wrong, or miss
context that a human author would understand. Do not blindly apply bot suggestions.

- Current branch: !`git branch --show-current`
- PR argument (if provided): $ARGUMENTS

## Step 1: Identify the PR

If `$ARGUMENTS` is provided, use it as the PR number or branch name.
Otherwise, use the current branch to find the PR:

```
gh pr view
```

## Step 2: Gather all review feedback

Fetch the PR diff, review comments, and review threads:

```
gh pr view <number> --comments
gh pr diff <number>
gh api repos/{owner}/{repo}/pulls/<number>/reviews
gh api repos/{owner}/{repo}/pulls/<number>/comments
```

## Step 3: Evaluate each review comment

For every review comment or requested change:

1. **Read the relevant code** that the comment refers to — including surrounding context, not just the line mentioned.
2. **Understand the suggestion** — what is the bot asking for?
3. **Critically assess validity** — apply your own judgement:
   - Does the bot actually understand the code, or is it pattern-matching superficially?
   - Is the suggestion correct? Would it introduce a bug or break something?
   - Does it conflict with the project's existing patterns or conventions?
   - Is it a real improvement or just unnecessary churn?
4. **Categorize** each comment as:
   - **Fix** — the bot caught a real issue (bug, missing error handling, actual style violation). Fix it.
   - **Skip** — the bot is wrong, nitpicking, or the suggestion doesn't make sense in context. Ignore it.
   - **Ask** — the suggestion is debatable or you're unsure. Flag it for the user.

Present a summary table to the user before making any changes:

| # | File | Comment | Verdict | Reason |
|---|------|---------|---------|--------|

## Step 4: Fix valid issues

For all comments you categorized as "Fix":

1. Make the code changes.
2. Run the appropriate checks (lint, typecheck, format) for the affected service.
3. Briefly summarize what you changed.

For "Ask" items, present them and let the user decide.
For "Skip" items, briefly explain why you're ignoring them.

## Guidelines

- Do NOT commit or push changes automatically — let the user decide when to commit.
- Be skeptical of bot suggestions — they lack the context you have. Read the code yourself.
- Bot reviewers often suggest unnecessary abstractions, over-engineering, or changes that conflict with project conventions. Push back on those.
- When fixing issues, follow the existing code style and patterns in the codebase.
- If a review comment references a file you haven't read, read it first before deciding.
- Comments from human reviewers should be treated with higher trust than bot comments.
