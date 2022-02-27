ZONE_ID=""
RECORD_ID=""
RECORD_NAME=""
AUTH_TOKEN=""
MY_PUBLIC_IP="$(dig whoami.cloudflare ch txt @1.1.1.1 +short)"
CURRENT_IP="\"$(dig +short ${RECORD_NAME} @1.1.1.1)\""
TTL=60

echo "Public IP: ${MY_PUBLIC_IP}"
echo "IP currently in DNS: ${CURRENT_IP}"

if [ "$MY_PUBLIC_IP" != "$CURRENT_IP" ]; then

        echo "Updating Cloudflare ${RECORD_NAME} with public IP ${MY_PUBLIC_IP}"

        curl -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
                -H "Authorization: Bearer ${AUTH_TOKEN}" \
                -H "Content-Type: application/json" \
                --data "{\"type\":\"A\",\"name\":\"${RECORD_NAME}\",\"content\":${MY_PUBLIC_IP},\"ttl\":${TTL},\"proxied\":false}"
else
    echo "IP addresses are the same, no update required."
fi
echo
