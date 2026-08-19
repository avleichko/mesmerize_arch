#!/usr/bin/env bash
# Assemble SAD + ADRs + NFRs + agent docs into a developer PDF.
# Requires: pandoc, Google Chrome (macOS).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$ROOT/output_docs/dev-pack"
STAMP="$(date +%Y-%m-%d)"
MD="$OUT_DIR/Mesmerize_Developer_Architecture_Pack.md"
HTML="$OUT_DIR/Mesmerize_Developer_Architecture_Pack.html"
PDF="$OUT_DIR/Mesmerize_Developer_Architecture_Pack.pdf"
DIAG_ABS="$ROOT/output_docs/output_diagrams"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"

mkdir -p "$OUT_DIR"

cat > "$OUT_DIR/dev-pack.css" <<'CSS'
@page { margin: 16mm 12mm; size: A4; }
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
  font-size: 10.5pt;
  line-height: 1.45;
  color: #111;
  max-width: 960px;
  margin: 0 auto;
  padding: 12px 16px 48px;
}
h1 {
  font-size: 1.55rem;
  border-bottom: 2px solid #222;
  padding-bottom: 0.25em;
  page-break-before: always;
  break-before: page;
}
/* Cover / first H1 should not force a blank first page */
body > h1:first-of-type,
#title-block-header + #TOC + h1,
header + h1 { page-break-before: avoid; break-before: avoid; }
h2 { font-size: 1.2rem; margin-top: 1.35em; }
h3 { font-size: 1.05rem; }
table {
  border-collapse: collapse;
  width: 100%;
  font-size: 0.88em;
  margin: 0.8em 0;
  page-break-inside: avoid;
}
th, td { border: 1px solid #ccc; padding: 4px 6px; vertical-align: top; }
th { background: #f3f3f3; }
img { max-width: 100%; height: auto; page-break-inside: avoid; }
code, pre {
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 0.85em;
}
pre {
  background: #f6f8fa;
  padding: 8px;
  overflow-x: auto;
  white-space: pre-wrap;
}
blockquote { border-left: 3px solid #999; margin-left: 0; padding-left: 12px; color: #333; }
#TOC { page-break-after: always; break-after: page; }
a { color: #0b57d0; text-decoration: none; }
.page-break { page-break-before: always; break-before: page; height: 0; }
CSS

rewrite_paths() {
  sed -E \
    -e "s|\]\(\.\./\.\./output_diagrams/([^)]+)\)|]($DIAG_ABS/\1)|g" \
    -e "s|\]\(\.\./\.\./\.\./output_diagrams/([^)]+)\)|]($DIAG_ABS/\1)|g"
}

append_file() {
  local title="$1"
  local file="$2"
  if [[ ! -f "$file" ]]; then
    echo "WARN: missing $file" >&2
    return 0
  fi
  {
    echo ""
    echo '<div class="page-break"></div>'
    echo ""
    echo "# $title"
    echo ""
    rewrite_paths < "$file"
    echo ""
  } >> "$MD"
}

{
  cat <<EOF
---
title: "Mesmerize Content Evidence Platform — Developer Architecture Pack"
subtitle: "SAD chapters · ADRs · NFRs · agent docs"
author: "Mesmerize architecture repo (working Markdown pack)"
date: "$STAMP"
---

# Developer Architecture Pack

**Generated:** $STAMP  
**Source:** mesmerize architecture working pack  
**SAD maturity:** ~79% (band 75 — Review-ready). Not stakeholder-sign-off complete while Chapter 18 Q-rows remain open.  
**Rule:** Do not invent Confirmed Region / CIDR / RTO / RPO / numeric SLOs. Prefer \`kb/\` + \`docs/adr/\` over guessing.

## How to use this pack

1. Start with **AGENTS.md** invariants and the **ADR decision register**.
2. Use **SAD chapters 01–18** for architecture narrative.
3. Treat **ASR-marked NFRs** as binding for design and code boundaries.
4. Open items live in **SAD Chapter 18** (A-01…A-10, Q-01…Q-14).

## Contents

1. Agent entrypoint (AGENTS.md)
2. Project context & current state
3. Architecture, engineering rules, security, testing, glossary
4. NFR catalog + ASR checklist
5. ADR register + ADR-001…016
6. SAD working pack index + progress + coverage
7. SAD chapters 01–18

EOF
} > "$MD"

append_file "AGENTS.md — Agent entrypoint" "$ROOT/AGENTS.md"
append_file "PROJECT_CONTEXT" "$ROOT/docs/ai/PROJECT_CONTEXT.md"
append_file "CURRENT_STATE" "$ROOT/docs/ai/CURRENT_STATE.md"
append_file "ARCHITECTURE" "$ROOT/docs/ai/ARCHITECTURE.md"
append_file "ENGINEERING_RULES" "$ROOT/docs/ai/ENGINEERING_RULES.md"
append_file "SECURITY" "$ROOT/docs/ai/SECURITY.md"
append_file "TESTING" "$ROOT/docs/ai/TESTING.md"
append_file "GLOSSARY" "$ROOT/docs/ai/GLOSSARY.md"

append_file "NFR catalog (docs/ai/NFR.md)" "$ROOT/docs/ai/NFR.md"
append_file "NFR catalog export" "$ROOT/output_docs/nfr/NFR_CATALOG.md"
append_file "ASR checklist" "$ROOT/output_docs/nfr/ASR_CHECKLIST.md"

append_file "ADR decision register" "$ROOT/docs/adr/README.md"
for adr in \
  001-content-evidence-not-ambient-scribe.md \
  002-zero-phi-on-mesmerize-servers.md \
  003-documentreference-engagement-writeback.md \
  004-athena-pilot-ehr-agnostic-core.md \
  005-smart-oauth-ehr-launch-mvp-scopes.md \
  006-icd10-content-match-cpt-billing-output.md \
  007-extend-pwa-server-mediated-devices.md \
  008-engagement-telemetry-billing-hitl-writeback.md \
  009-dicom-imaging-out-of-sow-scope.md \
  010-technology-stack.md \
  011-do-not-build.md \
  012-c4-persons-vs-stakeholders.md \
  013-multitenancy-silo-and-bridge.md \
  014-sqs-messaging-patterns.md \
  015-aws-deployment-reference.md \
  016-git-branching-and-delivery-ladders.md
do
  append_file "ADR — $adr" "$ROOT/docs/adr/$adr"
done

append_file "SAD working pack README" "$ROOT/output_docs/sad/README.md"
append_file "SAD progress" "$ROOT/output_docs/sad/PROGRESS.md"
append_file "SAD coverage checklist" "$ROOT/output_docs/sad/COVERAGE.md"

for ch in \
  01-purpose.md \
  02-scope.md \
  03-related-documents.md \
  04-definitions-and-acronyms.md \
  05-business-context.md \
  06-solution-scope.md \
  07-functional-architecture.md \
  08-system-architecture.md \
  09-data-architecture.md \
  10-security-and-privacy.md \
  11-multitenancy.md \
  12-messaging-and-integration.md \
  13-deployment-and-infrastructure.md \
  14-nfr-and-quality-attributes.md \
  15-key-terms-and-abbreviations.md \
  16-revision-history.md \
  17-ci-cd.md \
  18-assumptions-and-open-questions.md
do
  append_file "SAD Chapter — $ch" "$ROOT/output_docs/sad/chapters/$ch"
done

echo "Assembled Markdown: $MD ($(wc -c < "$MD" | tr -d ' ') bytes)"

pandoc "$MD" \
  -o "$HTML" \
  --standalone \
  --embed-resources \
  --toc \
  --toc-depth=2 \
  --metadata title="Mesmerize Developer Architecture Pack" \
  -c "$OUT_DIR/dev-pack.css" \
  --resource-path="$ROOT:$ROOT/output_docs:$DIAG_ABS:$ROOT/output_docs/sad/chapters" \
  2>"$OUT_DIR/pandoc.log"

echo "HTML: $HTML ($(wc -c < "$HTML" | tr -d ' ') bytes)"
if [[ -s "$OUT_DIR/pandoc.log" ]]; then
  echo "Pandoc log (tail):"
  tail -30 "$OUT_DIR/pandoc.log" || true
fi

if [[ ! -x "$CHROME" ]]; then
  echo "ERROR: Chrome not found at $CHROME" >&2
  exit 1
fi

HTML_URL="file://$HTML"
rm -f "$PDF"

set +e
"$CHROME" \
  --headless=new \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf="$PDF" \
  "$HTML_URL" \
  >"$OUT_DIR/chrome.log" 2>&1
rc=$?
set -e

if [[ ! -s "$PDF" ]]; then
  echo "Chrome first attempt failed (rc=$rc). Retry with --no-sandbox..."
  tail -20 "$OUT_DIR/chrome.log" || true
  "$CHROME" \
    --headless=new \
    --disable-gpu \
    --no-sandbox \
    --no-pdf-header-footer \
    --print-to-pdf="$PDF" \
    "$HTML_URL" \
    >>"$OUT_DIR/chrome.log" 2>&1
fi

if [[ ! -s "$PDF" ]]; then
  echo "ERROR: PDF not created. See $OUT_DIR/chrome.log" >&2
  tail -40 "$OUT_DIR/chrome.log" || true
  exit 1
fi

ls -lh "$PDF" "$HTML" "$MD"
echo "Done: $PDF"
