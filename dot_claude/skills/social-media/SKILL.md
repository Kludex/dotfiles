---
name: social-media
description: Draft social media posts for LinkedIn and Twitter/X. Use when the user wants to create, write, or share something on social media. Always generates both LinkedIn and Twitter versions.
user-invocable: false
---

# social-media

Draft social media posts for **LinkedIn** and **Twitter/X** based on the given topic or context.

## Input

`$ARGUMENTS` — the topic, announcement, link, or context to post about. This can be a description, a URL, a project name, or any relevant context.

## Instructions

1. **Understand the context** — If `$ARGUMENTS` references a file, URL, PR, or project, read/fetch it first to extract key details.

2. **Draft both versions** simultaneously:

### Twitter/X post
- Max 280 characters (hard limit)
- Punchy, concise, conversational tone
- Use 1-3 relevant hashtags only if they add discovery value
- Include a link if one was provided
- Front-load the hook — first line matters most

### LinkedIn post
- 1-3 short paragraphs (keep it under 1300 characters for full visibility without "see more")
- Professional but authentic tone — not corporate-speak
- Open with a hook line that grabs attention
- Use line breaks for readability
- End with a call to action or question to drive engagement
- Include 3-5 relevant hashtags at the end
- Include a link if one was provided

3. **Present both drafts** clearly labeled to the user.

4. **Ask the user** which version to copy to clipboard (or both), then use `printf '%s' "..." | pbcopy` to copy the selected post.

## Tone guidelines

- Sound like a real person, not a brand account
- Avoid buzzwords: "excited to announce", "thrilled", "game-changer", "leverage"
- Be specific over generic — concrete details beat vague enthusiasm
- Match the user's voice if prior posts are available as context
