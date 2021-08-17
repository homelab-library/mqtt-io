FROM python:3.9-alpine as builder
WORKDIR /build
RUN mkdir -p /dist
RUN pip install --use-feature=in-tree-build --root /dist --no-warn-script-location mqtt-io

FROM python:3.9-alpine
COPY --from=builder /dist/ /
CMD [ "python3", "-m", "mqtt_io", "/etc/config.yml" ]
