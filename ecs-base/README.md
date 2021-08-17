# molindo-ecs-base

**The Amazon ECS-optimized Amazon Linux AMI is deprecated as of April 15, 2021. After that date, Amazon ECS will continue providing critical and important security updates for the AMI but will not add support for new features.**

AMI built on top of the [Amazon Linux ECS AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)
for use in an autoscaling ECS instance cluster.

- available as `molindo-ecs-base-{{timestamp}}`
- available in `us-east-1`, `eu-west-1`, `eu-central-1`

### Variables

variables are set in `/etc/profile.d/01-ec2-env.sh` and written by `update-ec2-env.sh` during startup.

* `EC2_REGION`
* `EC2_INSTANCE_ID`
* `EC2_VPC_ID`
* `AWS_DEFAULT_REGION` (for aws-cli)

### Scripts

* `ec2-instances.sh` - get a list of EC2 instances in this TIM environment
* `ec2-tag.sh` - get an instance tag value
* `ephemeral-fstab.sh` - write an `/etc/fstab` entry for an ephemeral volume
* `ebs-fstab.sh` - write an `/etc/fstab` entry for an EBS volume
* `efs-fstab.sh` - write an `/etc/fstab` entry for an EFS volume

### Configuration

Configuration can be done by running commands [using EC2 user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
and [molindo-tim-infrastructure includes](http://cfm.molindo-build.net/), e.g.

```
Content-Type: multipart/mixed; boundary=MULTIPART
MIME-Version: 1.0

--MULTIPART
Content-Type: text/cloud-config

bootcmd:
 - [ /usr/bin/cloud-init-per, once, ephemeral_fstab, /usr/local/bin/ephemeral-fstab.sh, /mnt/ephemeral, ext4 ]

mounts:
 - [ swap, null ]

swap:
   filename: /swap.img
   size: auto
   maxsize: 8G

--MULTIPART
Content-Type: text/x-include-url

http://cfm.molindo-build.net/ecs-agent

--MULTIPART--
```

## AMIs

Based on the [Amazon ECS-Optimized Amazon Linux AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-ami-versions.html#ecs-ami-versions-linux).

### Source `ami-08b3fd22c78a217d5`

* ecs container agent `1.25.1`
* docker `18.06.1-ce`
* ecs-init `1.25.1-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0efd9342a1952d210` |
| eu-west-1    | `ami-05a2873e19b63f646` |
| us-east-1    | `ami-007dc926c8b925ab4` |

### Source `ami-07ba9ca2923346c0c`

* ecs container agent `1.25.3`
* docker `18.06.1-ce`
* ecs-init `1.25.3-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-08c6b04be15dfe01c` |
| eu-west-1    | `ami-0e1e6a04752d129d2` |
| us-east-1    | `ami-01400df578bc54180` |

### Source `ami-042ae7188819e7e9b`

* ecs container agent `1.26.0`
* docker `18.06.1-ce`
* ecs-init `1.26.0-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0e0f8bda08cb8cc8c` |
| eu-west-1    | `ami-09aa5aa8daa677776` |
| us-east-1    | `ami-03de1edcb8077f39d` |

### Source `ami-06a20f16dd2f50741`

* ecs container agent `1.28.0`
* docker `18.06.1-ce`
* ecs-init `1.28.0-1`

#### Changelog

* Increased Docker volume size to 50G

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0e4672d7c55f574ad` |
| eu-west-1    | `ami-0949ddf030c0f8604` |
| us-east-1    | `ami-013f94853e6738d25` |

### Source `ami-0bceb1887b6b37130`

* ecs container agent `1.29.1`
* docker `18.06.1-ce`
* ecs-init `1.29.1-1`

#### Changelog

* Enable `ECS_ENABLE_CONTAINER_METADATA`

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0d02c4b0e57fb1ac8` |
| eu-west-1    | `ami-0963062c0015da611` |
| us-east-1    | `ami-09b4bb44d27992b13` |

### Source `ami-0d3da340bcd9173b1`

* ECS-Optimized Amazon Linux `2018.03.20191114`
* ecs container agent `1.33.0`
* docker `18.06.1-ce`
* ecs-init `1.33.0-1`

#### Changelog

* Enable `ECS_ENABLE_SPOT_INSTANCE_DRAINING`

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-076b4feec1c9d9866` |
| eu-west-1    | `ami-0021537c8d39d78dd` |
| us-east-1    | `ami-0aa686abcc170fd47` |

### Source `ami-07facec38b7d326d7`

* ECS-Optimized Amazon Linux `2018.03.20191114`
* ecs container agent `1.36.1`
* docker `18.09.9-ce`
* ecs-init `1.36.1-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-04db43902aea26465` |
| eu-west-1    | `ami-0c51d901eac41429a` |
| us-east-1    | `ami-0ed0b4d6f92f39162` |

### Source `ami-067a0bc8aa37e5843`

* ECS-Optimized Amazon Linux `2018.03.20200218`
* ecs container agent `1.37.0`
* docker `18.09.9-ce`
* ecs-init `1.37.0-2`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0987e6f0cc11d9cb7` |
| eu-west-1    | `ami-0b88ab68a4853e85c` |
| us-east-1    | `ami-0ccd925fc8d0d8b64` |

### Source `ami-04e4ffaf92ae1dabf`

* ECS-Optimized Amazon Linux `2018.03.20201130`
* ecs container agent `1.48.1`
* docker `19.03.13-ce`
* ecs-init `1.48.1-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0f51a6cedff1679a6` |
| eu-west-1    | `ami-0845f0d26a06d00c3` |
| us-east-1    | `ami-0238dafe228c048d2` |

### Source `ami-05da5c64b0fc65424`

* ECS-Optimized Amazon Linux `2018.03.20210106`
* ecs container agent `1.49.0`
* docker `19.03.13-ce`
* ecs-init `1.49.0-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0fd620d590fb4f331` |
| eu-west-1    | `ami-01bc830606f381d62` |
| us-east-1    | `ami-09249eb1caf96628a` |

### Source `ami-050fd85feecf20f61`

* ECS-Optimized Amazon Linux `2018.03.20210723`
* ecs container agent `1.51.0`
* docker `19.03.13-ce`
* ecs-init `1.51.0-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-09f4bccbf33a7b36c` |
| eu-west-1    | `ami-0178ed83b5b4f4563` |
| us-east-1    | `ami-07c7078ab1cf6732a` |
