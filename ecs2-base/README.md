# molindo-ecs2-base

AMI built on top of the [Amazon Linux 2 ECS AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)
for use in an autoscaling ECS instance cluster.

- available as `molindo-ecs2-base-{{timestamp}}`
- available in `us-east-1`, `eu-west-1`, `eu-central-1`

### Variables

variables are set in `/etc/profile.d/01-ec2-env.sh` and written by `update-ec2-env.sh` during startup (after `cloud-init`).

* `EC2_REGION`
* `EC2_INSTANCE_ID`
* `EC2_VPC_ID`
* `AWS_DEFAULT_REGION` (for aws-cli)
* `EC2_ELASTIC_IP`

### Scripts

* `ec2-instances.sh` - get a list of EC2 instances in this TIM environment
* `ec2-tag.sh` - get an instance tag value
* `ephemeral-fstab.sh` - write an `/etc/fstab` entry for an ephemeral volume
* `ebs-fstab.sh` - write an `/etc/fstab` entry for an EBS volume
* `efs-fstab.sh` - write an `/etc/fstab` entry for an EFS volume

### Configuration

Configuration can be done by running commands [using EC2 user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html), e.g.

```
Content-Type: text/cloud-config

bootcmd:
 - [ /usr/bin/cloud-init-per, once, ephemeral_fstab, /usr/local/bin/ephemeral-fstab.sh, /mnt/ephemeral, ext4 ]

mounts:
 - [ swap, null ]

swap:
   filename: /swap.img
   size: auto
   maxsize: 8G
```

Note that `cloud-init` will run as part of `systemd` startup and therefore running `systemctl` may lead to deadlocked startup.

## AMIs

Based on the [Amazon ECS-Optimized Amazon Linux 2 AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-ami-versions.html#ecs-ami-versions-linux)
([Changelog](https://github.com/aws/amazon-ecs-ami/blob/main/CHANGELOG.md)).

### Source `ami-0102ef3da1a6c47ca`

* ECS-Optimized Amazon Linux 2 `20210805`
* ecs container agent `1.55.0`
* docker `19.03.13-ce`
* ecs-init `1.55.0-1`

#### Changelog

* Upgraded from `ecs-base` to use Amazon Linux 2

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-046242d612bfbcf33` |
| eu-west-1    | `ami-036d733508d23cd99` |
| us-east-1    | `ami-02a1cc4424093e4e7` |

### Source `ami-02662254373ce730d`

* ECS-Optimized Amazon Linux 2 `20210922`
* ecs container agent `1.55.3`
* docker `20.10.7`
* ecs-init `1.55.3-1`

#### Changelog

* source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-000bc5d83e5cad991` |
| eu-west-1    | `ami-075a110c7a53e3874` |
| us-east-1    | `ami-00628bf20fe9a459d` |

### Source `ami-088d915ff2a776984`

* ECS-Optimized Amazon Linux 2 `20210922`
* ecs container agent `1.57.0`
* docker `20.10.7`
* ecs-init `1.57.0-1`

#### Changelog

* source
* removed obsolete `/dev/xvdcz` mapping

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0f7bb136202d3e5d8` |
| eu-west-1    | `ami-0f9921735f59eb90d` |
| us-east-1    | `ami-08af1b713938709cc` |

### Source `ami-0262c9b663f67241e`

* ECS-Optimized Amazon Linux 2 `20220421`
* ecs container agent `1.61.0`
* docker `20.10.7`
* ecs-init `1.61.0-1`

#### Changelog

* source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-03ac94426c41acb7e` |
| eu-west-1    | `ami-0c02421a8eb61bf86` |
| us-east-1    | `ami-021324c2cc8d1fd63` |

### Source `ami-093cfc6e8a3d255f9`

* ECS-Optimized Amazon Linux 2 `20220520`
* ecs container agent `1.61.1`
* docker `20.10.13`
* ecs-init `1.61.1-1`

#### Changelog

* source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0516d526feea6929d` |
| eu-west-1    | `ami-095c4c8cb9ccea87f` |
| us-east-1    | `ami-0c182eea632269105` |

### Source `ami-08f4df18aa6f249eb`

* ECS-Optimized Amazon Linux 2 `20221102`
* ecs container agent `1.65.1`
* docker `20.10.17`
* ecs-init `1.65.1-1`

#### Changelog

* source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-088ea0535b1e597ac` |
| eu-west-1    | `ami-08bce6d43c97f7595` |
| us-east-1    | `ami-0ce552fda2727e89f` |

### Source `ami-0b5009e7f102539b1`

* ECS-Optimized Amazon Linux 2 `20230809`
* ecs container agent `1.75.0`
* docker `20.10.23`
* ecs `1.75.0-1`

#### Changelog

* source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-08fa252ac682a4b52` |
| eu-west-1    | `ami-02590f7e2a5f8360e` |
| us-east-1    | `ami-01176f6ee32645c9c` |

### Source `ami-0b19e4398ca560e6a`

* ECS-Optimized Amazon Linux 2 `2.0.20240131`
* ECS container agent `1.80.0`
* Docker version `20.10.25`

#### Changelog

* source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-04e25aa8fbf710697` |
| eu-west-1    | `ami-073ef4077d915f599` |
| us-east-1    | `ami-07f791fe289394528` |
