#!/bin/bash
# Sitemap Generator for https://vicegax.com (Clean URLs)
# Run this script directly from your website's root folder.

DOMAIN="https://vicegax.com"
SITEMAP_FILE="sitemap.xml"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$SITEMAP_FILE"
echo "<urlset xmlns=\"http://sitemaps.org\">" >> "$SITEMAP_FILE"

# 1. Add the main root index.html as the homepage
if [ -f "index.html" ]; then
    echo "  <url>" >> "$SITEMAP_FILE"
    echo "    <loc>${DOMAIN}/</loc>" >> "$SITEMAP_FILE"
    echo "    <priority>1.0</priority>" >> "$SITEMAP_FILE"
    echo "  </url>" >> "$SITEMAP_FILE"
fi

# 2. Find other HTML files at the root level (excluding index.html)
for file in *.html; do
    if [ -f "$file" ] && [ "$file" != "index.html" ]; then
        # Remove the .html extension
        clean_path="${file%.html}"
        echo "  <url>" >> "$SITEMAP_FILE"
        echo "    <loc>${DOMAIN}/${clean_path}</loc>" >> "$SITEMAP_FILE"
        echo "    <priority>0.8</priority>" >> "$SITEMAP_FILE"
        echo "  </url>" >> "$SITEMAP_FILE"
    fi
done

# 3. Find HTML files precisely one level deep
for file in */*.html; do
    if [ -f "$file" ]; then
        # Check if it is a subdirectory index file (e.g., blog/index.html)
        if [[ "$file" == */index.html ]]; then
            # Strip index.html entirely to target just the directory path
            clean_path="${file%/index.html}"
        else
            # Strip only the .html extension
            clean_path="${file%.html}"
        fi
        echo "  <url>" >> "$SITEMAP_FILE"
        echo "    <loc>${DOMAIN}/${clean_path}</loc>" >> "$SITEMAP_FILE"
        echo "    <priority>0.6</priority>" >> "$SITEMAP_FILE"
        echo "  </url>" >> "$SITEMAP_FILE"
    fi
done

echo "</urlset>" >> "$SITEMAP_FILE"
echo "Success: Created $SITEMAP_FILE with clean URLs!"
