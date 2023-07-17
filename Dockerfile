FROM hashicorp/vault:1.10.3

RUN apk add --no-cache py-pip ca-certificates && pip install s3cmd

COPY vault-backuper.sh /app/vault-backuper.sh

WORKDIR /app

ENTRYPOINT ["/bin/sh", "/app/vault-backuper.sh"]
