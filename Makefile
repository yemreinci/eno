ifndef TAG
	TAG ?= $(shell date +%s)
endif

ENO_CONTROLLER_IMAGE_VERSION ?= $(TAG)
ENO_CONTROLLER_IMAGE_NAME ?= eno-controller
ENO_RECONCILER_IMAGE_VERSION ?= $(TAG)
ENO_RECONCILER_IMAGE_NAME ?= eno-reconciler

.PHONY: docker-build-eno-controller
docker-build-eno-controller:
	docker build \
		--file docker/$(ENO_CONTROLLER_IMAGE_NAME)/Dockerfile \
		--tag $(REGISTRY)/$(ENO_CONTROLLER_IMAGE_NAME):$(ENO_CONTROLLER_IMAGE_VERSION) .
	docker push $(REGISTRY)/$(ENO_CONTROLLER_IMAGE_NAME):$(ENO_CONTROLLER_IMAGE_VERSION)

.PHONY: docker-build-eno-reconciler
docker-build-eno-reconciler:
	docker build \
		--file docker/$(ENO_RECONCILER_IMAGE_NAME)/Dockerfile \
		--tag $(REGISTRY)/$(ENO_RECONCILER_IMAGE_NAME):$(ENO_RECONCILER_IMAGE_VERSION) .
	docker push $(REGISTRY)/$(ENO_RECONCILER_IMAGE_NAME):$(ENO_RECONCILER_IMAGE_VERSION)

# Setup controller-runtime test environment binaries
.PHONY: setup-testenv
setup-testenv:
	@echo "Installing controller-runtime testenv binaries..."
	@go run sigs.k8s.io/controller-runtime/tools/setup-envtest@latest use -p path

.PHONY: builddeploy
builddeploy: 
	@echo "Using TAG=$(TAG)"
	@echo "Building..."
	TAG=$(TAG) ./dev/build-linux.sh 
	@echo "Applying CRDs..."
	kubectl apply -f api/v1/config/crd/
	@echo "Deploying..."
	TAG=$(TAG) envsubst < dev/deploy.yaml | kubectl apply -f -