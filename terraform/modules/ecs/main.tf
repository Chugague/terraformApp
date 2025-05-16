resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  tags = {
    Name = "csgtest"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = var.container_name
      image     = var.image
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ],
      environment = var.environment_variables
    }
  ])

  tags = {
    Name = "csgtest"
  }
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = {
    Name = "csgtest"
  }

  depends_on = [aws_ecs_task_definition.this]
}
