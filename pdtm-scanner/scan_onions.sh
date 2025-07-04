#!/bin/bash

echo "Starting onion scanning with PDTM and httpx..."

# Create output directory
mkdir -p /app/output

# Wait for Tor to be ready
echo "Waiting for Tor to bootstrap..."
sleep 30
echo "Tor should be ready now, proceeding with scan..."

# Check if CSV file exists
if [ ! -f "/app/onions_results.csv" ]; then
    echo "Error: onions_results.csv not found!"
    exit 1
fi

# Extract URLs from CSV (skip header)
echo "Extracting URLs from CSV..."
tail -n +2 /app/onions_results.csv | cut -d',' -f1 > /app/output/onions_list.txt

# Count total URLs
TOTAL_URLS=$(wc -l < /app/output/onions_list.txt)
echo "Found $TOTAL_URLS URLs to scan"

# Scan with httpx through Tor
echo "Starting httpx scan through Tor proxy..."
cat /app/output/onions_list.txt | httpx \
    -proxy socks5://tor:9050 \
    -title \
    -status-code \
    -content-length \
    -tech-detect \
    -server \
    -method \
    -response-time \
    -threads 10 \
    -timeout 30 \
    -retries 2 \
    -rate-limit 5 \
    -ms "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
    -json \
    -output /app/output/httpx_results.json

# Create summary report
echo "Generating summary report..."
if [ -f "/app/output/httpx_results.json" ] && [ -s "/app/output/httpx_results.json" ]; then
    cat /app/output/httpx_results.json | jq -r '
        [
            "URL,Status,Title,Server,Tech,Content-Length,Response-Time",
            (.[] | [.url, .status_code, .title, .server, (.tech[]? // ""), .content_length, .response_time] | @csv)
        ] | .[]
    ' > /app/output/scan_summary.csv

    # Count successful responses
    SUCCESS_COUNT=$(cat /app/output/httpx_results.json | jq -s 'map(select(.status_code == 200)) | length')
    echo "Scan completed!"
    echo "Total URLs scanned: $TOTAL_URLS"
    echo "Successful responses (200): $SUCCESS_COUNT"
    echo "Results saved to:"
    echo "  - JSON: /app/output/httpx_results.json"
    echo "  - CSV: /app/output/scan_summary.csv"

    # Show top 10 successful results
    echo ""
    echo "Top 10 successful results:"
    cat /app/output/httpx_results.json | jq -r 'select(.status_code == 200) | "\(.url) - \(.title // "No title")"' | head -10
else
    echo "Error: httpx scan failed or produced no results"
    echo "Check if the httpx command completed successfully"
    ls -la /app/output/
fi