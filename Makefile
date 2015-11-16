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
	pwd=$$(pwd) ; \
		cd $${TMPDIR:-/tmp} ; \
		atomic uninstall kolab/atomicapp ; \
		docker build -t kolab/atomicapp $${pwd}/atomicapp/. ; \
		sudo rm -rf \
			answers.conf \
			answers.conf.sample \
			artifacts/ \
			Dockerfile \
			Nulecule \
			external/ ; \
		atomic install kolab/atomicapp

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
	while [ ! -z "$$(docker images -aq)" ]; do \
		for image in $$(docker images -aq); do \
			docker rmi -f $$image 2>/dev/null || : ; \
		done ; \
	done

.PHONY: all docs push
