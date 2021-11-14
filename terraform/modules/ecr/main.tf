resource "aws_ecr_repository" "helloworld_overkill" {
  name = "helloworld-overkill"
}

resource "aws_ecr_lifecycle_policy" "helloworld_overkill" {
  repository = aws_ecr_repository.helloworld_overkill.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
