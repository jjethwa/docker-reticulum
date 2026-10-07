#!/usr/bin/env bash

python -m venv .venv && source .venv/bin/activate && pip install pip --upgrade

RNS_BUILD_VERSION_RNS=$(pip index versions rns --json |jq -r '.latest')

if [[ -z ${RNS_BUILD_VERSION_RNS-} ]]; then
	echo "ERROR: Could not determine latest rns version, RNS_BUILD_VERSION_RNS not set"
	exit $?
else
	echo "Using rns version ${RNS_BUILD_VERSION_RNS}"
fi

RNS_BUILD_VERSION_LXMF=$(pip index versions lxmf --json |jq -r '.latest')

if [[ -z ${RNS_BUILD_VERSION_LXMF-} ]]; then
	echo "ERROR: Could not determine latest lxmf version, RNS_BUILD_VERSION_LXMF not set"
	exit $?
else
	echo "Using lxmf version ${RNS_BUILD_VERSION_LXMF}"
fi


if [[ -n ${RNS_BUILD_DOCKER_USER-} && -n ${RNS_BUILD_DOCKER_PASSWORD-} ]]; then
	echo "${RNS_BUILD_DOCKER_PASSWORD}" | docker login -u "${RNS_BUILD_DOCKER_USER}" --password-stdin || exit $?
fi

docker build . \
        -t "reticulum:latest" \
	--build-arg IMAGE_CREATED=$(date -uIseconds) \
	--build-arg IMAGE_REVISION=${RNS_BUILD_VERSION_RNS} \
        --build-arg VERSION_RNS=${RNS_BUILD_VERSION_RNS} \
        --build-arg VERSION_LXMF=${RNS_BUILD_VERSION_LXMF}

if [[ -n ${RNS_BUILD_DOCKER_USER-} && -n ${RNS_BUILD_DOCKER_PASSWORD-} ]]; then
	echo "Uploading images to: Docker Hub"
        if [[ -z ${RNS_BUILD_DOCKER_REPOSITORY-} ]]; then
                RNS_BUILD_DOCKER_REPOSITORY=${RNS_BUILD_DOCKER_USER}
        fi
	if [[ -z ${RNS_BUILD_DOCKER_IMAGE-} ]]; then
		RNS_BUILD_DOCKER_IMAGE=reticulum
	fi

        docker tag reticulum:latest ${RNS_BUILD_DOCKER_REPOSITORY}/${RNS_BUILD_DOCKER_IMAGE}:latest
        docker tag reticulum:latest ${RNS_BUILD_DOCKER_REPOSITORY}/${RNS_BUILD_DOCKER_IMAGE}:${RNS_BUILD_VERSION_RNS}

        docker push ${RNS_BUILD_DOCKER_REPOSITORY}/${RNS_BUILD_DOCKER_IMAGE}:latest
        docker push ${RNS_BUILD_DOCKER_REPOSITORY}/${RNS_BUILD_DOCKER_IMAGE}:${RNS_BUILD_VERSION_RNS}

	docker logout
fi


if [[ -n ${RNS_BUILD_CR_USER-} && -n ${RNS_BUILD_CR_HOST-} ]]; then
	echo "Uploading images to: ${RNS_BUILD_CR_HOST}"
	if [[ -z ${RNS_BUILD_CR_REPOSITORY-} ]]; then
		RNS_BUILD_CR_REPOSITORY=${RNS_BUILD_CR_USER}
	fi
	if [[ -z ${RNS_BUILD_CR_IMAGE-} ]]; then
		RNS_BUILD_CR_IMAGE=reticulum
	fi
	if [[ -z ${RNS_BUILD_CR_PASSWORD-} ]]; then
		RNS_BUILD_CR_PASSWORD=${GITHUB_TOKEN}
	fi

	echo "${RNS_BUILD_CR_PASSWORD}" | \
		docker login -u "${RNS_BUILD_CR_USER}" "${RNS_BUILD_CR_HOST}" --password-stdin || exit $?

	docker tag reticulum:latest ${RNS_BUILD_CR_HOST}/${RNS_BUILD_CR_REPOSITORY}/${RNS_BUILD_CR_IMAGE}:latest
        docker tag reticulum:latest ${RNS_BUILD_CR_HOST}/${RNS_BUILD_CR_REPOSITORY}/${RNS_BUILD_CR_IMAGE}:${RNS_BUILD_VERSION_RNS}

        docker push ${RNS_BUILD_CR_HOST}/${RNS_BUILD_CR_REPOSITORY}/${RNS_BUILD_CR_IMAGE}:latest
        docker push ${RNS_BUILD_CR_HOST}/${RNS_BUILD_CR_REPOSITORY}/${RNS_BUILD_CR_IMAGE}:${RNS_BUILD_VERSION_RNS}
	
	docker logout
fi

