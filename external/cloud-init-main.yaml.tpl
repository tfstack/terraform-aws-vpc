#cloud-config
package_update: true
package_upgrade: true

write_files:
  - path: /etc/cloudwatch-agent.sh
    permissions: '0755'
    content: |
      ${indent(6, cloudwatch_user_data)}
%{ if user_data != "" }
  - path: /etc/user-data.sh
    permissions: '0755'
    content: |
      ${indent(6, user_data)}
%{ endif }

runcmd:
  - echo "Running cloudwatch-agent user-data"
  - /etc/cloudwatch-agent.sh
  - echo "Running custom user-data"
%{ if user_data != "" }
  - /etc/user-data.sh
%{ endif }
