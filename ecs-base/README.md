# molindo-ecs-base

AMI built on top of the [Amazon ECS AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html) for
use in an autoscaling ECS instance cluster.

- available as `molindo-ecs-base-{{timestamp}}`
- available in `us-east-1`, `eu-west-1`, `eu-central-1`

## AMIs

Based on the [Amazon ECS-Optimized Amazon Linux AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html).

### Source `ami-0b9fee3a2d0596ed1`

* ecs container agent `1.21.0`
* docker `18.06.1-ce`
* ecs-init `1.21.0-1`

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0054bc15950bb571a` |
| eu-west-1    | `ami-00398a7eede1b4999` |
| us-east-1    | `ami-070765cfbb0b56739` |

### Source `ami-0eaa3baf6969912ba`

* ecs container agent `1.22.0`
* docker `18.06.1-ce`
* ecs-init `1.22.0-1`

#### Changelog

* Added `/usr/local/bin/ephemeral-fstab.sh`
* Added `/usr/local/bin/elb-fstab.sh`
* Install `vim`
* Install `nvme-cli`

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-029d811f1a7469947` |
| eu-west-1    | `ami-0b43f031c445d3e14` |
| us-east-1    | `ami-050db184d95ffd566` |

### Source `ami-0e4ccc6bc8b6243c4`

* ecs container agent `1.25.0`
* docker `18.06.1-ce`
* ecs-init `1.25.0-1`

#### Changelog

* Source only

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-058fb96636b5db307` |
| eu-west-1    | `ami-0b453299810d88e8c` |
| us-east-1    | `ami-04aded2f12d86499c` |
