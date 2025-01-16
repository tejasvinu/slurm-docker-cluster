.PHONY: all clean allclean

all: base/image_done master/image_done node/image_done jupyter/image_done

base/image_done:
	cd base && make

master/image_done: base/image_done
	cd master && make

node/image_done: base/image_done
	cd node && make

jupyter/image_done: base/image_done
	cd jupyter && make

clean:
	-rm */image_done

allclean: clean
	-docker rmi slurm-base:latest slurm-master:latest slurm-node:latest slurm-jupyter:latest
