MY_PUBLIC_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
ZONE_ID=""
RECORD_ID=""
RECORD_NAME=""
AUTH_TOKEN=""
TTL=60

echo "Updating Cloudflare with public IP ${myip}"

curl -X PUT "https://api.cloudflare.com/client/v4/zones/'${ZONE_ID}'/dns_records/'${RECORD_ID}'" \
        -H "Authorization: Bearer AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'${RECORD_NAME}'","content":"'${MY_PUBLIC_IP}'","ttl":'${TTL}',"proxied":false}'
echo
