#cloud-config
package_update: true
package_upgrade: true
packages:
%{ for pkg in packages ~}
  - ${pkg}
%{ endfor ~}
