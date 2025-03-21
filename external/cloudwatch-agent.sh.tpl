#!/bin/bash

bash -c "$(curl -fsSL https://raw.githubusercontent.com/jdevto/cli-tools/refs/heads/main/scripts/install_rsyslog.sh)" -- install --configure
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jdevto/cli-tools/refs/heads/main/scripts/install_cloudwatch_agent.sh)" -- install --region ${aws_region} --configure
