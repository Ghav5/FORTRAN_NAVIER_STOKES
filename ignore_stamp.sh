#!/usr/bin/env bash
set -e

echo "🔧 Setting up Git filter to ignore timestamps in JSON files..."

# 1. Configure the filter (replace ALL timestamp fields)
git config filter.ignore-timestamp.clean \
"sed -E 's/\"timestamp\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"timestamp\": \"IGNORE\"/g'"

git config filter.ignore-timestamp.smudge cat

# 2. Create or update .gitattributes
if [ ! -f .gitattributes ]; then
  touch .gitattributes
fi

# Add rule only if not already present
if ! grep -q '*.json filter=ignore-timestamp' .gitattributes; then
  echo '*.json filter=ignore-timestamp' >> .gitattributes
fi

# 3. Normalize existing files (IMPORTANT)
echo "📦 Normalizing existing JSON files..."
git add --renormalize .

echo "✅ Setup complete!"
echo "👉 Now Git will ignore timestamp-only changes in all JSON files."