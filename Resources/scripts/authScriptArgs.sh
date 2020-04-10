#!/bin/bash

usage="Usage: $0 authKey authKeyId teamId\n\n

	where:\n
		\t- authKey : absolute path of authKey file (.p8)\n
		\t- authKeyId : XXX on authKey file named AuthKey_XXX.p8\n
		\t- teamId : teamId of the account\n"

# if [ $# -ne 3 ]; then
# 	echo $usage > /dev/stderr
# 	exit 1
# fi

# authKey=$1
# authKeyId=$2
# teamId=$3


authKey="../auth/AuthKey_4W2QJ2R2WS.p8"
authKeyId="4W2QJ2R2WS"
teamId="UTT7VDX8W5"

base64() {
   openssl base64 -e -A | tr -- '+/' '-_' | tr -d =
}

sign() {
   printf "$1"| openssl dgst -binary -sha256 -sign "$authKey" | base64
}

time=$(date +%s)
header=$(printf '{ "alg": "ES256", "kid": "%s" }' "$authKeyId" | base64)
claims=$(printf '{ "iss": "%s", "iat": %d }' "$teamId" "$time" | base64)
jwt="$header.$claims.$(sign $header.$claims)"

printf $jwt