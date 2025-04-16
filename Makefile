# TODO: Change env vars to files

# Repository versions
SALEOR_VERSION = 3.20.80
SALEOR_DASHBOARD_VERSION = 3.20.34
SALEOR_PLATFORM_VERSION = latest
STOREFRONT_VERSION = latest

LOCAL_REGISTRY = k3d-higiliqs.local:12345

REPOS = \
    https://github.com/saleor/saleor.git@$(SALEOR_VERSION) \
    https://github.com/saleor/saleor-dashboard.git@$(SALEOR_DASHBOARD_VERSION) \
    https://github.com/saleor/saleor-platform.git@$(SALEOR_PLATFORM_VERSION) \
    https://github.com/saleor/storefront.git@$(STOREFRONT_VERSION)

.PHONY: cluster apply_all delete_all

cluster:
	k3d registry create higiliqs.local -p 12345
	k3d cluster create higiliqs -p "80:80@loadbalancer" --agents 5 --registry-use k3d-higiliqs.local:12345

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

apply_local:
	KUBECONFIG= kubectl apply -f kube/namespace.yml && \
	KUBECONFIG= kustomize build kube/overlays/local | KUBECONFIG= kubectl apply -n higiliquidos -f -

apply_local_windows:
	kubectl apply -f kube/namespace.yml && \
	kustomize build kube/overlays/local | kubectl apply -n higiliquidos -f -

apply_prod:
	kustomize build kube/overlays/prod | kubectl apply -n higiliquidos -f -

delete_local:
	KUBECONFIG= kustomize build kube/overlays/local | KUBECONFIG= kubectl delete -n higiliquidos -f -

delete_local_windows:
	kustomize build kube/overlays/local | kubectl delete -n higiliquidos -f -

delete_prod:
	KUBECONFIG=/vagrant/kubeconfig kustomize build kube/overlays/prod | KUBECONFIG=/vagrant/kubeconfig kubectl delete -n higiliquidos -f -

build_push_local:
	@for dockerfile in dockerfiles/Dockerfile.*; do \
		from_tag=$$(grep '^FROM' $$dockerfile | head -n1 | awk '{print $$2}' | sed 's|.*/||'); \
		full_tag=$(LOCAL_REGISTRY)/$${from_tag}; \
		echo "Building $$dockerfile as $$full_tag..."; \
		docker build -f $$dockerfile -t $$full_tag .; \
		echo "Pushing $$full_tag..."; \
		docker push $$full_tag; \
	done