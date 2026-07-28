# Email Love agent instructions for OpenAI Codex

Teach [OpenAI Codex](https://developers.openai.com/codex) to build real, export-ready emails
inside your Figma file from your [Email Love](https://emaillove.com) design system.

Codex has no skills system, so the instructions ship as [`AGENTS.md`](AGENTS.md), the file
Codex loads automatically as persistent context.

## Install

**1. Save the instructions**

```bash
curl -o ~/.codex/AGENTS.md https://raw.githubusercontent.com/email-love/codex-agents/main/AGENTS.md
```

That applies everywhere. To scope it to one project, save it at that project's root instead.
If you already have an `AGENTS.md`, paste ours in as a section rather than replacing the file.

**2. Connect Figma**

```bash
codex mcp add figma --url https://mcp.figma.com/mcp
codex mcp login figma
```

Use the **remote** server. The local one does not expose the write tools this workflow needs.

**3. Ask for an email**

Talk to Codex normally and share your Figma file link:

> Build a promo email in https://figma.com/design/... Spring sale, 20% off with code SPRING20, ends Sunday, one CTA to the pricing page.

You never mention the instruction file again.

**4. Approve the `use_figma` tool calls**

Every canvas write goes through that one tool, and a build fires dozens of them. If you
decline, or the session cannot prompt you, Codex reports that the Figma write tools "aren't
connected" and builds nothing, even though your connection is fine. This is the most common
thing that goes wrong. For unattended runs (`codex exec`), pass
`--dangerously-bypass-approvals-and-sandbox`.

## Requirements

- Codex CLI, app, or IDE extension (verified on CLI 0.133.0)
- The remote Figma MCP server connected, with access to your file
- The Email Love Figma plugin (latest version) and a [synced design system](https://help.emaillove.com/plugin/components/design-systems) in that file

## Using Claude instead?

The same workflow ships as a Claude skill and Claude Code plugin at
[email-love/claude-skills](https://github.com/email-love/claude-skills).

ChatGPT chat cannot build emails in Figma: its Figma app only creates FigJam diagrams,
Figma Slides, and Figma Buzz assets, and cannot edit Figma Design files.

## Documentation

[help.emaillove.com/plugin/ai/agents-in-figma](https://help.emaillove.com/plugin/ai/agents-in-figma)

## Support

Email [hello@emaillove.com](mailto:hello@emaillove.com) and we'll respond within a business day.
