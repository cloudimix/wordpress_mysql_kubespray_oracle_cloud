#!/bin/bash
.ONESHELL:

.PHONY: kubespray
kubespray:
	git clone -b release-2.19 --single-branch https://github.com/kubernetes-sigs/kubespray.git
	cp -nprf kubespray/* myfiles/* .

.PHONY: k8s
k8s:
	/usr/bin/env python3 -m venv venv
	. venv/bin/activate
	pip install -r requirements.txt
	ansible-playbook id_rsa_generating.yml
	terraform init
	terraform apply -auto-approve
	if [ ! -f ~/.vault_pass ]; then echo testpass > ~/.vault_pass; fi
	ansible-galaxy install -r requirements.yml
	ansible-playbook -i dynamic_inventory.py --vault-password-file ~/.vault_pass -b -u=root main.yml -vv
	ansible-playbook -i dynamic_inventory.py kubectl_localhost.yml -vv

.PHONY: app
app:
	ansible-playbook wp_deploy.yml -vv
	kubectl get pod
	terraform output LB_public_ip

.PHONY: clean
clean:
	rm -rf kubespray/

.PHONY: all
all: kubespray k8s app

.PHONY: test
test:
