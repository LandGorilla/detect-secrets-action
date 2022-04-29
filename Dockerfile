FROM alpine:3.14

RUN apk update && apk upgrade && apk --no-cache add bash git less openssh && pip install detect-secrets==1.2.0

COPY entrypoint.sh /entrypoint.sh

ENV DS_REQUIRE_BASELINE=0 DS_ADDL_ARGS="" DS_BASELINE_FILE="./.secrets.baseline"

ENTRYPOINT ["/entrypoint.sh"]
