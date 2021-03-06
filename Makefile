BRANCH	:= $(shell git rev-parse --abbrev-ref HEAD | sed -e 's/master/latest/g')
NOCACHE	:= $(shell test 0$(NOCACHE) -eq 0 || echo "--no-cache")

all: docs
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		echo "== $$image ==" ; \
		docker build \
			-t kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g'):$(BRANCH) \
			$$image/. ; \
		docker tag -f kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g'):$(BRANCH) \
			docker.io/kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g'):$(BRANCH) ; \
	done

list:
	@for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		echo "kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g'):$(BRANCH)" ; \
	done

docs:
	make -C docs clean html || :

pull:
	docker pull centos:centos7 && \
		docker tag -f docker.io/library/centos:centos7 centos:centos7
	docker pull centos/mariadb && \
		docker tag -f docker.io/centos/mariadb centos/mariadb
	docker pull projectatomic/mariadb-centos7-atomicapp && \
		docker tag -f docker.io/projectatomic/mariadb-centos7-atomicapp projectatomic/mariadb-centos7-atomicapp
	docker pull projectatomic/atomicapp:latest && \
		docker tag -f docker.io/projectatomic/atomicapp:latest projectatomic/atomicapp:latest
	docker pull projectatomic/atomicapp:0.2.1 && \
		docker tag -f docker.io/projectatomic/atomicapp:0.2.1 projectatomic/atomicapp:0.2.1
	docker pull microwebapps/haproxy-frontend-atomicapp:latest && \
		docker tag -f docker.io/microwebapps/haproxy-frontend-atomicapp:latest microwebapps/haproxy-frontend-atomicapp:latest
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		docker pull kolab/$$(basename $${image} | sed -r -e 's/[0-9]+-//g'):$(BRANCH) && \
			docker tag -f docker.io/kolab/$$(basename $${image} | sed -r -e 's/[0-9]+-//g'):$(BRANCH) kolab/$$(basename $${image} | sed -r -e 's/[0-9]+-//g'):$(BRANCH) || : ; \
	done

push:
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		docker push --force docker.io/kolab/$$(basename $${image} | sed -r -e 's/[0-9]+-//g'):$(BRANCH) ; \
	done

run: clean all
	sudo atomicapp --verbose install --destination /var/lib/atomicapp/kolab-atomicapp/ kolab/atomicapp:$(BRANCH) && \
		cd /var/lib/atomicapp/kolab-atomicapp/ && \
		sed \
			-e 's/_password = None/_password = welcome123/g' \
			-e 's/^mongodb_database = None/mongodb_database = manticore/g' \
			-e 's/^mongodb_username = None/mongodb_username = manticore/g' \
			-e 's/^db_user = None/db_user = kolab/g' \
			-e 's/^db_name = None/db_name = kolab/g' \
			-e 's/^db_pass = None/db_pass = welcome123/g' \
			answers.conf.sample | sudo tee answers.conf && \
		sudo atomicapp --verbose run -a /var/lib/atomicapp/kolab-atomicapp/answers.conf kolab/atomicapp:$(BRANCH) || \
		sudo atomicapp --verbose -a /var/lib/atomicapp/kolab-atomicapp/answers.conf run kolab/atomicapp:$(BRANCH)

clean:
	for replicationcontroller in $$(kubectl get --no-headers=true replicationcontrollers | awk '{print $$1}' | grep -v kubernetes); do \
		kubectl delete replicationcontroller $${replicationcontroller} 2>/dev/null || : ; \
	done
	for service in $$(kubectl get --no-headers=true services | awk '{print $$1}' | grep -v kubernetes); do \
		kubectl delete service $${service} 2>/dev/null || : ; \
	done
	for pod in $$(kubectl get --no-headers=true pods | awk '{print $$1}' | grep -v kubernetes); do \
		kubectl delete pod $${pod} 2>/dev/null || : ; \
	done
	for container in $$(docker ps -q); do \
		docker kill --signal="SIGKILL" $${container} 2>/dev/null || : ; \
	done
	for container in $$(docker ps -aq); do \
		docker rm $${container} ; \
	done
	for image in $$(docker images -q --filter dangling=true); do \
		docker rmi $${image} ; \
	done
	sudo rm -rf /var/lib/atomicapp/kolab-atomicapp/ || :

really-clean:
	while [ ! -z "$$(docker images -aq)" ]; do \
		for image in $$(docker images -aq); do \
			docker rmi -f $${image} 2>/dev/null || : ; \
		done ; \
	done

restart:
	for service in kubelet kube-apiserver kube-scheduler kube-controller-manager kube-proxy etcd; do \
		sudo systemctl stop $${service} ; \
	done
	for service in kubelet kube-apiserver kube-scheduler kube-controller-manager kube-proxy etcd; do \
		sudo systemctl start $${service} ; \
	done
	for service in kubelet kube-apiserver kube-scheduler kube-controller-manager kube-proxy etcd; do \
		sudo systemctl status $${service} >/dev/null 2>&1 || sudo systemctl restart $${service}; \
	done

%:
	docker build $(NOCACHE) -t kolab/$@:$(BRANCH) *-$@
	docker tag -f kolab/$@:$(BRANCH) docker.io/kolab/$@:$(BRANCH)

.PHONY: all docs push
