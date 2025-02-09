# **Terraform Module: AWS VPC Setup with Jumphost User Data**

## **Overview**

This Terraform module provisions an AWS VPC along with public, private, isolated, and database subnets. It also sets up a jump host (`jumphost`) with ingress rules restricted to the user's public IP.

The jump host supports multiple ways to define `user_data` for instance initialization:

- **No User Data (Default)**
- **Inline Script (`jumphost_user_data`)** - Directly pass a shell script.
- **File-Based (`jumphost_user_data_file`)** - Use an existing script file.
- **Template-Based (`jumphost_user_data_template`)** - Generate Cloud-Init dynamically using `templatefile()`.

## **Usage**

### **1. No User Data (Default)**

If no user data is provided, the instance launches without any custom initialization.

```hcl
module "aws_vpc" {
  source = "../.."

  region             = "ap-southeast-1"
  vpc_name           = "vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

  jumphost_subnet        = "10.0.0.0/24"
  jumphost_ingress_cidrs = ["${data.http.my_public_ip.response_body}/32"]
  jumphost_instance_type = "t3.micro"
  jumphost_allow_egress  = true
}
```

---

### **2. Inline User Data (Direct Script)**

Pass a shell script directly in Terraform.

```hcl
module "aws_vpc" {
  source = "../.."

  jumphost_user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname jumphost
  EOF
}
```

---

### **3. User Data from a File**

Load an external script file and apply it as `user_data`.

#### **Create the file `cloud-init.sh`**

```bash
#!/bin/bash
echo "Hello, this is from a file!" > /tmp/hello.txt
```

#### **Use Terraform to load the file**

```hcl
module "aws_vpc" {
  source = "../.."
  jumphost_user_data_file = "${path.module}/cloud-init.sh"
}
```

---

### **4. User Data from a Template**

Use `templatefile()` to inject dynamic values into Cloud-Init.

#### **Create a template file: `cloud-init.yaml.tpl`**

```yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
%{ for pkg in packages ~}
  - ${pkg}
%{ endfor ~}
```

#### **Use Terraform to apply the template**

```hcl
module "aws_vpc" {
  source = "../.."
  jumphost_user_data_template = "${path.module}/cloud-init.yaml.tpl"
  jumphost_user_data_template_vars = {
    packages = ["jq", "curl"]
  }
}
```

## **Requirements**

- Terraform >= 1.0.0
- AWS Provider >= 4.0

## **License**

MIT License
