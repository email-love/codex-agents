# Security and data handling

## Figma access

The Email Love skills depend on the official remote Figma MCP. Figma OAuth and any
`FIGMA_TOKEN` remain separate credentials.

- Grant only the scopes required by the workflow.
- Never paste a token into a prompt, Figma layer, converter payload, issue, or repository
  file.
- Keep the source file read-only during a design-system migration.
- Review every target-file write through the active Codex approval policy.

The standard setup does not require disabling Codex sandboxing. The
`--dangerously-bypass-approvals-and-sandbox` option grants authority far beyond Figma and is
not the recommended way to use this plugin.

## Design-converter service

Path B and migration conversion send a rendered PNG of customer-provided design material to:

```text
https://design-converter.andy-30d.workers.dev
```

The converter request contains the screenshot and may contain pinned design metadata such as
text content, font names, colors, dimensions, and frame structure.

The current workflow documents a 24-hour result cache keyed by screenshot hash unless
`nocache=1` is used. `recache=1` refreshes a cached result. Before processing sensitive,
regulated, confidential, or personally identifiable material:

1. Confirm that sending the render to this service is permitted.
2. Remove recipient data, credentials, private merge values, and unrelated customer content.
3. Use `nocache=1` when retention through the normal cache is inappropriate.
4. Store returned MJML JSON only in an approved location.

Do not send competitor previews or Email Love inspiration-library previews to the converter.

## Reporting a vulnerability

Do not open a public issue containing credentials, customer designs, or exploit details.
Email [hello@emaillove.com](mailto:hello@emaillove.com) with:

- the affected version;
- the security impact;
- reproduction steps;
- any relevant logs with secrets removed.
