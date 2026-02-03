FROM openclaw:local

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends golang-go ca-certificates \
    && GOBIN=/usr/local/bin go install github.com/Yakitrak/obsidian-cli@latest \
    && apt-get purge -y golang-go \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache/go-build /root/go

USER node
