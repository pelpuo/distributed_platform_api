all:
	(cd memfs && ./generate-mfs.sh)
	(cp -Rf src/* sample_project.sdk/sample_project/src/)
	(cd sample_project.sdk/sample_project_bsp && make all)
	(cd sample_project.sdk/sample_project/Debug && make all)

	echo SUCCESS

clean:
	$(eval USER_SRC := $(shell ls src | tr '\n' ' '))
	rm -f image.mfs
	(cd sample_project.sdk/sample_project/src/ && rm -f $(USER_SRC))
	(cd sample_project.sdk/sample_project_bsp && make clean)
	(cd sample_project.sdk/sample_project/Debug && make clean)

