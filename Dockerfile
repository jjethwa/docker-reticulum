FROM dhi.io/python:3.14-alpine-dev AS build

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH=$VIRTUAL_ENV/bin:$PATH

RUN pip install --no-cache-dir rns

FROM dhi.io/python:3.14-alpine

COPY --from=build /app/.venv /app/.venv

ENV VIRTUAL_ENV=/app/.venv
ENV PATH=/app/.venv/bin:$PATH

ENTRYPOINT ["rnsd"]
CMD ["-s"]
