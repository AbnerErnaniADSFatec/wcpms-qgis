#
# This file is part of Python QGIS Plugin for WCPMS.
# Copyright (C) 2025 INPE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.
#
#!/bin/bash

if [ "$QGIS_RELEASE" = "" ];
then
	echo "Using QGIS 3.42..."
	QGIS_RELEASE=3.42
fi

if [ "$BUILD" = "" ];
then
	echo "Building image for WCPMS-QGIS..."
	python3 ./scripts/build_requirements.py
	cp ./LICENSE ./wcpms_plugin/LICENSE
	ls -al

	bash ./scripts/linux/generate-zip.sh

	docker rmi wcpms_qgis/qgis:$QGIS_RELEASE --force

	docker build -t wcpms_qgis/qgis:$QGIS_RELEASE .
fi

mkdir .qgis/

xhost +local:docker

docker run -it \
	--rm \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v $PWD/.qgis/:$HOME \
	-v $PWD:/home/wcpms-qgis \
	--device /dev/dri \
	wcpms_qgis/qgis:$QGIS_RELEASE qgis
