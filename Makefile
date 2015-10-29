all:
	docker build -t kolab/base 00-base/.
	docker build -t kolab/base-imap 01-base-imap/.
	docker build -t kolab/base-mx 01-base-mx/.
	docker build -t kolab/base-web 01-base-web/.
	docker build -t kolab/base-ext-mx 02-base-ext-mx/.
	docker build -t kolab/imapb 03-imapb/.
	docker build -t kolab/imapf-ext 03-imapf-ext/.
	docker build -t kolab/imapf-int 03-imapf-int/.
	docker build -t kolab/imap-prx 03-imap-prx/.
	docker build -t kolab/roundcubemail 03-roundcubemail/.
	docker build -t kolab/wallace 03-wallace/.
	docker build -t kolab/imap 99-imap/.
	docker build -t kolab/mta 99-mta/.
	docker build -t kolab/webclient 99-webclient/.
	docker build -t kolab/atomicapp kolab/.

push:
	docker push \
		kolab/base \
		kolab/base-imap \
		kolab/base-mx \
		kolab/base-web \
		kolab/base-ext-mx \
		kolab/imapb \
		kolab/imapf-ext \
		kolab/imapf-int \
		kolab/imap-prx \
		kolab/roundcubemail \
		kolab/wallace \
		kolab/imap \
		kolab/mta \
		kolab/webclient \
		kolab/atomicapp

.PHONY: all
