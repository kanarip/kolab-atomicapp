all:
	docker build -t kolab/base 00-base/.
	docker build -t kolab/base-imap 01-base-imap/.
	docker build -t kolab/base-ldap 01-base-ldap/.
	docker build -t kolab/base-mx 01-base-mx/.
	docker build -t kolab/base-web 01-base-web/.
	docker build -t kolab/base-ext-mx 02-base-ext-mx/.
	docker build -t kolab/imapb 03-imapb/.
	docker build -t kolab/imapf-ext 03-imapf-ext/.
	docker build -t kolab/imapf-int 03-imapf-int/.
	docker build -t kolab/imap-prx 03-imap-prx/.
	docker build -t kolab/ldap-master 03-ldap-master/.
	docker build -t kolab/roundcubemail 03-roundcubemail/.
	docker build -t kolab/wallace 03-wallace/.
	docker build -t kolab/imap 99-imap/.
	docker build -t kolab/ldap 99-ldap/.
	docker build -t kolab/mta 99-mta/.
	docker build -t kolab/webclient 99-webclient/.
	docker build -t kolab/atomicapp kolab/.

push:
	docker push kolab/base
	docker push kolab/base-imap
	docker push kolab/base-ldap
	docker push kolab/base-mx
	docker push kolab/base-web
	docker push kolab/base-ext-mx
	docker push kolab/imapb
	docker push kolab/imapf-ext
	docker push kolab/imapf-int
	docker push kolab/imap-prx
	docker push kolab/ldap-master
	docker push kolab/roundcubemail
	docker push kolab/wallace
	docker push kolab/imap
	docker push kolab/ldap
	docker push kolab/mta
	docker push kolab/webclient
	docker push kolab/atomicapp

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
		docker rmi $$image 2>/dev/null || : ; \
	done

.PHONY: all push
