all: docs
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		echo "== $$image ==" ; \
		docker build \
			-t kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g') \
			$$image/. ; \
	done

list:
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		echo "kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g')" ; \
	done

docs:
	make -C docs clean html || :

pull:
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort | grep -vE '^\./0[0-9]-base'); do \
		docker pull kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g') || : ; \
	done

push:
	for image in $$(find . -mindepth 2 -maxdepth 2 -type f -name "Dockerfile" -exec dirname {} \; | sort); do \
		docker push kolab/$$(basename $$image | sed -r -e 's/[0-9]+-//g') ; \
	done

run: clean all
	sudo atomicapp --verbose install --destination /var/lib/atomicapp/kolab-atomicapp/ kolab/atomicapp && \
		cd /var/lib/atomicapp/kolab-atomicapp/ && \
		sed \
			-e 's/_password = None/_password = welcome123/g' \
			-e 's/^mongodb_database = None/mongodb_database = manticore/g' \
			-e 's/^mongodb_username = None/mongodb_username = manticore/g' \
			answers.conf.sample | sudo tee answers.conf && \
		sudo atomicapp --verbose -a /var/lib/atomicapp/kolab-atomicapp/answers.conf run kolab/atomicapp

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
		docker kill --signal="SIGKILL" $${container} || : ; \
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

.PHONY: all docs push
