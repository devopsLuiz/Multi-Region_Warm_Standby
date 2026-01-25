output "ecs_instance_profile"{

    value = aws_iam_instance_profile.ecs_instance_profile.id

}

output "ecs_task_execution_role"{

    value = aws_iam_role.ecs_task_execution_role.arn
}

