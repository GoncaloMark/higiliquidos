# TODO: Change env vars to files | Clean up secrets

# Repository versions
SALEOR_VERSION = 3.20.80
SALEOR_DASHBOARD_VERSION = 3.20.34
SALEOR_PLATFORM_VERSION = latest
STOREFRONT_VERSION = latest
PAYMENT_VERSION = main

LOCAL_REGISTRY = k3d-registry.higiliquidos.svc.cluster.local:12345

REPOS = \
    https://github.com/saleor/saleor.git@$(SALEOR_VERSION) \
    https://github.com/saleor/saleor-dashboard.git@$(SALEOR_DASHBOARD_VERSION) \
    https://github.com/saleor/saleor-platform.git@$(SALEOR_PLATFORM_VERSION) \
    https://github.com/saleor/storefront.git@$(STOREFRONT_VERSION) \
	https://github.com/saleor/dummy-payment-app.git@$(PAYMENT_VERSION)

.PHONY: cluster apply_all delete_all

cluster:
	k3d registry create registry.higiliquidos.svc.cluster.local -p 12345
	k3d cluster create higiliqs -p "80:80@loadbalancer" --agents 5 --registry-use k3d-registry.higiliquidos.svc.cluster.local:12345

clone_all:
	mkdir -p repos
	@for repo in $(REPOS); do \
		repo_url=$$(echo $$repo | cut -d '@' -f 1); \
		version=$$(echo $$repo | cut -d '@' -f 2); \
		dir=$$(basename $$repo_url .git); \
		echo "Cloning $$dir..."; \
		git clone $$repo_url repos/$$dir; \
		cd repos/$$dir; \
		if [ "$$version" != "latest" ]; then \
			echo "Checking out version $$version for $$dir..."; \
			git checkout tags/$$version || git checkout $$version; \
		fi; \
		echo "Removing .git directory from $$dir..."; \
		rm -rf .git; \
		cd ../../; \
	done

pull_all:
	@for repo in $(REPOS); do \
		dir=$(basename $$repo .git); \
		if [ -d "repos/$$dir" ]; then \
			echo "Pulling updates for $$dir..."; \
			cd repos/$$dir && git pull; \
		else \
			echo "Repository $$dir does not exist in 'repos/'; skipping."; \
		fi; \
	done

apply-secrets:
	kubectl create secret generic cluster-secrets \
		--from-env-file=kube/overlays/local/.env \
		--namespace higiliquidos \
		--dry-run=client -o yaml | kubectl apply -f -

	kubectl create secret generic exporter-secrets \
		--from-env-file=kube/overlays/local/.env.exporters \
		--namespace higiliquidos \
		--dry-run=client -o yaml | kubectl apply -f -

	kubectl create secret generic saleor-secrets \
		--from-env-file=kube/overlays/local/.env.saleor \
		--namespace higiliquidos \
		--dry-run=client -o yaml | kubectl apply -f -

	kubectl create secret generic saleor-key \
		--from-file=RSA_PRIVATE_KEY=kube/overlays/local/RSA_PRIVATE_KEY.pem \
		--namespace higiliquidos \
		--dry-run=client -o yaml | kubectl apply -f -

	kubectl create secret generic saleor-dashboard-secrets \
		--from-env-file=kube/overlays/local/.env.saleor-dashboard \
		--namespace higiliquidos \
		--dry-run=client -o yaml | kubectl apply -f -

apply_local: add_operator add_argo
	KUBECONFIG= kubectl apply -f kube/namespace.yml && \
	make add_drone && \
	make apply-secrets && \
	KUBECONFIG= kubectl apply -n higiliquidos -f kube/crds/crds.yml && \
	KUBECONFIG= kustomize build kube/overlays/local | KUBECONFIG= kubectl apply -n higiliquidos -f -

apply_local_windows:
	kubectl apply -f kube/namespace.yml && \
	kustomize build kube/overlays/local | kubectl apply -n higiliquidos -f -

apply_prod:
	kustomize build kube/overlays/prod | kubectl apply -n higiliquidos -f -

delete_local:
	KUBECONFIG= kustomize build kube/overlays/local | KUBECONFIG= kubectl delete -n higiliquidos -f -

delete_prod:
	kustomize build kube/overlays/prod | kubectl delete -n higiliquidos -f -

build_push_local: build_push_saleor
	@for dockerfile in dockerfiles/Dockerfile.*; do \
		if [ "$$dockerfile" = "dockerfiles/Dockerfile.bckpg" ]; then \
			from_tag="bckpg:0.1.0"; \
		else \
			from_tag=$$(grep '^FROM' $$dockerfile | head -n1 | awk '{print $$2}' | sed 's|.*/||'); \
		fi; \
		full_tag=$(LOCAL_REGISTRY)/$${from_tag}; \
		echo "Building $$dockerfile as $$full_tag..."; \
		docker build -f $$dockerfile -t $$full_tag .; \
		echo "Pushing $$full_tag..."; \
		docker push $$full_tag; \
	done

build_push_saleor:
	cd repos/saleor && \
		docker build -t $(LOCAL_REGISTRY)/saleor:3.20.80 . && \
		docker push $(LOCAL_REGISTRY)/saleor:3.20.80

	cd repos/saleor-dashboard && \
		docker build -t $(LOCAL_REGISTRY)/saleor-dashboard:3.20.34 . && \
		docker push $(LOCAL_REGISTRY)/saleor-dashboard:3.20.34

	cd repos/dummy-payment-app && \
	docker build -f Dockerfile -t $(LOCAL_REGISTRY)/dummy-payment-app:0.1.0 . && \
	docker push $(LOCAL_REGISTRY)/dummy-payment-app:0.1.0

	cd scripts && \
	docker build -t $(LOCAL_REGISTRY)/register-payments:0.1.0 . && \
	docker push $(LOCAL_REGISTRY)/register-payments:0.1.0

build_storefront:
	cd repos/storefront && \
	docker build --build-arg NEXT_PUBLIC_SALEOR_API_URL=http://saleor-api.higiliquidos.svc.cluster.local/graphql/ --build-arg NEXT_PUBLIC_STOREFRONT_URL=http://store.higiliquidos.deti.com/ -t $(LOCAL_REGISTRY)/saleor-storefront:0.1.0 --network=host --add-host saleor-api.higiliquidos.svc.cluster.local:127.0.0.1 . && \
	docker push $(LOCAL_REGISTRY)/saleor-storefront:0.1.0

add_operator:
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.2/cert-manager.yaml
	kubectl wait --for=condition=Available --timeout=120s deployment/cert-manager -n cert-manager
	kubectl wait --for=condition=Available --timeout=120s deployment/cert-manager-webhook -n cert-manager
	kubectl wait --for=condition=Available --timeout=120s deployment/cert-manager-cainjector -n cert-manager
	kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
	kubectl wait --for=condition=Available --timeout=120s deployment/opentelemetry-operator-controller-manager -n opentelemetry-operator-system

add_argo:
	KUBECONFIG= kubectl apply -f kube/argo-ns.yml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
	KUBECONFIG= kustomize build kube/argo | KUBECONFIG= kubectl apply -n argocd -f -
	kubectl create secret generic higiliquidos-github-creds \
	--namespace argocd \
	--from-env-file=kube/overlays/local/.env.argo \
	--dry-run=client -o yaml | kubectl label -f - argocd.argoproj.io/secret-type=repository -n argocd --local -o yaml | kubectl apply -f -
	KUBECONFIG= kubectl -n argocd rollout restart deployment argocd-image-updater

add_drone:
	KUBECONFIG= kustomize build kube/drone | KUBECONFIG= kubectl apply -n higiliquidos -f -
