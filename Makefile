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

run:
	vagrant destroy ; \
		vagrant up ; \
		vagrant ssh --command 'atomic install kolab/atomicapp; sed -e "s/None/welcome123/g" answers.conf.sample > answers.conf'

clean:
	for container in $$(docker ps -q); do \
		docker kill --signal="SIGKILL" $$container ; \
	done
	for container in $$(docker ps -aq); do \
		docker rm $$container ; \
	done
	for image in $$(docker images -q --filter dangling=true); do \
		docker rmi $$image ; \
	done

really-clean:
	for image in $$(docker images -aq); do \
		docker rmi -f $$image 2>/dev/null || : ; \
	done

.PHONY: all docs push
