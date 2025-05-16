# 1. Proveedor AWS
provider "aws" {
  region = "us-east-1"  # Cambia si estás usando otra región
}

# 2. Red y subredes públicas
module "vpc" {
  source = "../../modules/vpc"
}

# 3. Security Group para el ALB y ECS
resource "aws_security_group" "ecs_sg" {
  name        = "pagerduty-test-sg"
  description = "Allow HTTP access to ECS service"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "csgtest"
  }
}

# 4. IAM Role para ECS Task Execution
module "iam" {
  source    = "../../modules/iam"
  role_name = "pagerduty-ecs-execution-role-prod"
}

# 5. Load Balancer y Target Group
module "alb" {
  source              = "../../modules/alb"
  alb_name            = "pagerduty-prod-alb"
  target_group_name   = "pagerduty-prod-tg"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [aws_security_group.ecs_sg.id]

}

# 6. ECS Cluster, Task y Service
module "ecs" {
  source = "../../modules/ecs"

  cluster_name         = "pagerduty-test-cluster"
  task_family          = "pagerduty-test-task"
  cpu                  = "256"
  memory               = "512"
  execution_role_arn   = module.iam.execution_role_arn
  container_name       = "pagerduty-angular"
  image                = "chugague/pagerduty-angular:latest"  # O tu imagen local si subes a ECR
  container_port       = 80
  service_name         = "pagerduty-test-service"
  desired_count        = 1

  environment_variables = [
    {
      name  = "ENV"
      value = "test"
    }
  ]

  subnet_ids            = module.vpc.public_subnet_ids
  security_group_ids    = [aws_security_group.ecs_sg.id]
  target_group_arn      = module.alb.target_group_arn
}
