# TODO: Change env vars to files

REPOS = \
    https://github.com/saleor/saleor.git \
    https://github.com/saleor/saleor-dashboard.git \
    https://github.com/saleor/saleor-platform.git \
	https://github.com/saleor/storefront.git

.PHONY: cluster apply_all delete_all

cluster:
	k3d registry create higiliqs.local -p 12345
	k3d cluster create higiliqs -p "8081:80@loadbalancer" --agents 5 --registry-use k3d-higiliqs.local:12345

clone_all:
	mkdir -p repos
	@for repo in $(REPOS); do \
		git clone $$repo repos/; \
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

apply_prod:
	KUBECONFIG=1 kubectl apply -f kube/namespace.yml && KUBECONFIG=1 kustomize build kube/overlays/prod | KUBECONFIG=1 kubectl apply -n higiliquidos -f -

delete_local:
	KUBECONFIG= kustomize build kube/overlays/local | KUBECONFIG= kubectl delete -n higiliquidos -f -

delete_prod:
	KUBECONFIG=1 kustomize build kube/overlays/prod | KUBECONFIG=1 kubectl delete -n higiliquidos -f -