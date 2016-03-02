OSFLAVOR=centos7
PGVERSION=9.3
docbuild:
	cd docs && ./build-docs.sh
pg:
	sudo docker build -t crunchy-ose-pg -f $(PGVERSION)/Dockerfile.$(OSFLAVOR) .
	sudo docker tag -f crunchy-ose-pg:latest crunchydata/crunchy-ose-pg
watch:
	sudo docker build -t crunchy-ose-watch -f $(PGVERSION)/Dockerfile.watch.$(OSFLAVOR) .
	sudo docker tag -f crunchy-ose-watch:latest crunchydata/crunchy-ose-watch
pgpool:
	sudo docker build -t crunchy-ose-pgpool -f $(PGVERSION)/Dockerfile.pgpool.$(OSFLAVOR) .
	sudo docker tag -f crunchy-ose-pgpool:latest crunchydata/crunchy-ose-pgpool
pgbadger:
	go get github.com/tools/godep
	cd src/github.com/crunchydata/openshift-dedicated-container/badger && godep restore && godep go install badgerserver.go
	sudo docker build -t crunchy-ose-pgbadger -f $(PGVERSION)/Dockerfile.pgbadger.$(OSFLAVOR) .
	sudo docker tag -f crunchy-ose-pgbadger:latest crunchydata/crunchy-ose-pgbadger
backup:
	sudo docker build -t crunchy-ose-backup -f $(PGVERSION)/Dockerfile.backup.$(OSFLAVOR) .
	sudo docker tag -f crunchy-ose-backup:latest crunchydata/crunchy-ose-backup

all:
	make pg
	make pgpool
	make pgbadger
	make backup
	make docbuild
default:
	all

