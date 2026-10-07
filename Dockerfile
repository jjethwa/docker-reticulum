FROM dhi.io/python:3.14-alpine-dev AS build

ARG VERSION_RNS
RUN test -n "$VERSION_RNS" || (echo "VERSION_RNS not set" && exit $?)

ARG VERSION_LXMF
RUN test -n "$VERSION_LXMF" || (echo "VERSION_LXMF not set" && exit $?)

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH=$VIRTUAL_ENV/bin:$PATH

RUN pip install --no-cache-dir rns==$VERSION_RNS lxmf==$VERSION_LXMF

FROM dhi.io/python:3.14-alpine

ARG IMAGE_CREATED=unknown
ARG IMAGE_REVISION=unknown

LABEL org.opencontainers.image.created=$IMAGE_CREATED \
    org.opencontainers.image.description="Docker container running rnsd" \
    org.opencontainers.image.revision=$IMAGE_REVISION \
    org.opencontainers.image.source="https://github.com/jjethwa/docker-reticulum" \
    org.opencontainers.image.title="reticulum container image" \
    org.opencontainers.image.url="https://github.com/jjethwa/docker-reticulum" \
    org.opencontainers.image.version=$IMAGE_REVISION

COPY --from=build /app/.venv /app/.venv

ENV VIRTUAL_ENV=/app/.venv
ENV PATH=/app/.venv/bin:$PATH

ENTRYPOINT ["rnsd"]
CMD ["-s"]

