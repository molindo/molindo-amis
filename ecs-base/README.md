# molindo-ecs-base

AMI built on top of the [Amazon ECS AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html) for
use in an autoscaling ECS instance cluster.

- available as `molindo-ecs-base-{{timestamp}}`
- available in `us-east-1`, `eu-west-1`, `eu-central-1`

## AMIs

Based on the [Amazon ECS-Optimized Amazon Linux AMI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html).

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
