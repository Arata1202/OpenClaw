FROM openclaw:local

USER root

# GitHub CLI & AWS CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       gh \
       awscli \
       ca-certificates \
       ffmpeg \
       python3 \
       python3-pip \
       python3-venv \
    && rm -rf /var/lib/apt/lists/*

# rclone (Google Drive)
RUN if command -v rclone >/dev/null 2>&1; then \
      rclone version; \
    else \
      curl -fsSL https://rclone.org/install.sh | bash; \
    fi

USER node
