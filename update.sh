#!/bin/bash
# からておけいこ アプリ更新スクリプト

echo "📦 ZIPを作成中..."
cd /Users/misato
rm -f workout-timer.zip
zip -r workout-timer.zip workout-timer/ -x "*.DS_Store" -x "*/.claude/*"

echo "🚀 Netlifyにデプロイ中..."
TOKEN="nfp_TuHUZmPKDhoTVAP2Q1858rNnyzrDvuMr88a6"
SITE_ID="98b8a180-3a20-4788-b13f-626db920c40e"

python3 - << PYEOF
import urllib.request, json

token = "${TOKEN}"
site_id = "${SITE_ID}"

with open('/Users/misato/workout-timer.zip', 'rb') as f:
    data = f.read()

req = urllib.request.Request(
    f'https://api.netlify.com/api/v1/sites/{site_id}/deploys',
    data=data,
    headers={
        'Content-Type': 'application/zip',
        'Authorization': f'Bearer {token}'
    },
    method='POST'
)
resp = json.loads(urllib.request.urlopen(req).read())
url = resp.get('ssl_url') or resp.get('deploy_ssl_url') or 'https://${SITE_ID}.netlify.app'
print(f"\n✅ 更新完了！\n👉 {url}\n")
PYEOF
