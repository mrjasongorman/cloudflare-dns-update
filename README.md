# Bind your public IP to Cloudflare managed DNS record

Very similar to dyndns, but talks to Cloudflare.

e.g  `subdomain.mywebsite.com` == `Your public IP address`

Assumptions: 
  1. You have your own domain
  2. You have it wired it up to Cloudflare
  3. This script will be run on Linux

## Authentication

This script assumes you've created an authentication token for Cloudflare. 

Go here to generate a token: [https://dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens)

Scope the token to only have DNS `read` and DNS `edit` permissions for your specific domain.

Then place that token somewhere secure and feed it into the `AUTH_TOKEN` variable in the script.

## Other Variables

**ZONE_ID**

This refers to your Zone ID in Cloudflare. You'll see this listed at the side of your screen in Cloudflare when you click into a domain.

**RECORD_ID**

This is the ID of the already created DNS record. You can create an initial record in the Cloudflare dashboard. Then grab the ID by using the following command:

```
curl -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records?type=A&name=SUBDOMAIN.YOURWEBSITE.COM" \
     -H "Authentication: Bearer YOUR_AUTH_TOKEN" \
     -H "Content-Type: application/json"
```

**RECORD_NAME**

This is the full URI for example if you have a record for `subdomain` it should be `subdomain.yourwebsite.com`

**MY_PUBLIC_IP**

This grabs your current public IP address by querying Open DNS. This can also be changed to query Googles resolver instead. Google it. 

**CURRENT_IP**

This grabs the current value that Cloudflare has saved for your `RECORD_NAME`, essentially just a DNS request to Cloudflares own DNS servers. It then compares it against `MY_PUBLIC_IP` to see if they're the same, and if not it updates Cloudflare.

**TTL=60**

This is intentially set to 60 seconds as that's the lowest value it can have. This will mean that any requests for the IP address behind `subdomain.yourwebsite.com` should only be cached by devices for 60 seconds. After that any further requests will hit Cloudflare again for the latest value.

Your public IP shouldn't change that frequently. But the combination of how often the script runs + this TTL ensure that when it does change it should correct itself relatively quickly.

## Automation

To automate this script add it as a cron job.

Run `$ crontab -e`

Then add something like

```
*/1 * * * * /bin/sh /home/path-to-script/update-dns-record.sh
```

This will execute the script every minute. Again depends on how much of a lag is acceptable between your IP changing and other external devices realising.
