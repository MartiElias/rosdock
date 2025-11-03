#!/bin/bash

# Nombre del contenedor e imagen
CONTAINER="ros_container"
IMAGE="ros"

# ¿Existe el contenedor?
if [ "$(docker ps -aq -f name=^${CONTAINER}$)" ]; then
    # ¿Está corriendo?
    if [ "$(docker ps -q -f name=^${CONTAINER}$)" ]; then
        echo "El contenedor '$CONTAINER' ya está corriendo. Conectando..."
        docker exec -it "$CONTAINER" /bin/bash
    else
        echo "El contenedor '$CONTAINER' existe pero está detenido. Arrancando..."
        docker start "$CONTAINER"
        docker exec -it "$CONTAINER" /bin/bash
    fi
fi
#else
#    echo "El contenedor '$CONTAINER' no existe. Creando y arrancando..."
#    docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v ./src:/home/ros-humble/src -e DISPLAY=${DISPLAY} -e "TERM=xterm-256color" --runtime=amd -e AMD_VISIBLE_DEVICES=0 --network host --name ros ros2_humble
#fi
