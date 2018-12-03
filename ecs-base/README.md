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

#### Regions

| Region       | AMI ID                  |
|--------------|-------------------------|
| eu-central-1 | `ami-0de8fb88bd730b5f2` |
| eu-west-1    | `ami-06ce051cc55a7a3ac` |
| us-east-1    | `ami-0edfe2efb13d5fc6b` |
