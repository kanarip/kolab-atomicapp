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

.PHONY: all
