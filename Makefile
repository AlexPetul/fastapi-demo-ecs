ECS_CLUSTER = fastapi-demo-cluster
ECS_SERVICE = fastapi-main-service
ECS_TASK_DEFINITION = fastapi-demo-task-definition-family
ECR_HOST = 353586219743.dkr.ecr.us-east-1.amazonaws.com

IMAGE_NAME = fastapi-demo

APP_VERSION ?= master.$(shell git rev-parse --short=8 HEAD)

DATA_ROOT_DIR ?= $(CURDIR)

aws-alembic-migrate:
	@ aws ecs run-task \
		--cluster $(ECS_CLUSTER) \
		--task-definition $(ECS_TASK_DEFINITION):$(shell cat $(DATA_ROOT_DIR)/$(ECS_TASK_DEFINITION).rev) \
		--count 1 \
		--launch-type FARGATE \
		--network-configuration "awsvpcConfiguration={subnets=[subnet-0d2b2f554fb0a3013,subnet-0733a5d6e186fa913],securityGroups=[sg-04404962fa02f3fb4],assignPublicIp=ENABLED}" \
		--overrides '{"containerOverrides": [{"name": "$(IMAGE_NAME)", "command": ["alembic", "upgrade", "head"]}]}'

aws-update-service:
	@ aws ecs update-service \
		--cluster $(ECS_CLUSTER) \
		--service $(ECS_SERVICE) \
		--desired-count 1 \
		--task-definition $(ECS_TASK_DEFINITION):$(shell cat $(DATA_ROOT_DIR)/$(ECS_TASK_DEFINITION).rev)

aws-perform-update-task-definition:
	@ aws ecs describe-task-definition \
 		--task-definition "$(ECS_TASK_DEFINITION)" | jq '.taskDefinition | .containerDefinitions[0].image = "$(ECR_IMAGE)" | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) | del(.registeredAt) | del(.registeredBy)' > $(DATA_ROOT_DIR)/$(ECS_TASK_DEFINITION).json

	@ aws ecs register-task-definition \
 		--cli-input-json file://$(DATA_ROOT_DIR)/$(ECS_TASK_DEFINITION).json | jq '.taskDefinition.revision' > $(DATA_ROOT_DIR)/$(ECS_TASK_DEFINITION).rev

aws-update-task-definition:
	@ ECR_IMAGE="$(ECR_HOST)/$(IMAGE_NAME):$(APP_VERSION)" TASK_DEFINITION="$(ECS_TASK_DEFINITION)" make aws-perform-update-task-definition

aws-clean:
	@ rm -rf $(DATA_ROOT_DIR)/*.json $(DATA_ROOT_DIR)/*.rev

aws-deploy: aws-update-task-definition aws-alembic-migrate aws-update-service aws-clean