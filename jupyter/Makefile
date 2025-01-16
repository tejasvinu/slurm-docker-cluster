.PHONY: allclean

image_done: Dockerfile docker-entrypoint.sh
	docker buildx build -t slurm-jupyter:latest .
	touch image_done

allclean:
	-rm image_done
