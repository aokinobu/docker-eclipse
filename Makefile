image_name = aoki/docker-eclipse
container_name = docker-eclipse
port_num = 8080
container_port_num = 8080
media_path = /home/aoki/
interface_path = /workspace
container_interface_path = /home/developer/workspace

setup:		build run
		echo "Completed."
setup-nc:	build-nc run
		echo "Completed."
build:
		docker build -t $(image_name) .
build-nc:
		docker build --no-cache -t $(image_name) .
start:
		docker run -ti --rm -e DISPLAY=$(DISPLAY) -v /tmp/.X11-unix:/tmp/.X11-unix -v /opt/maven:/home/developer/.m2 -v $(media_path)/eclipse/.eclipse:/home/developer/.eclipse -v $(media_path)$(interface_path):$(container_interface_path)  --name $(container_name) $(image_name)

exec:
		docker exec -it $(container_name) /bin/bash
destroy:	stop rm rmi
		echo "Completed."
clean:		stop rm
		echo "Completed."
stop:
		docker stop $(container_name)
restart:
		docker restart $(container_name)
rm:
		docker rm $(container_name)
rmi:
		docker rmi $(image_name)
logs:
		docker logs $(container_name)
