version=latest
repository=mwaaas/dynamodb_local_mock_unsupported_api:$(version)

deploy:
	docker build -t $(repository) .
	docker push $(repository)
