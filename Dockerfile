FROM python:3.9-alpine as builder
WORKDIR /build

RUN apk update && mkdir -p /dist
RUN apk add build-base git libffi-dev rust cargo openssl-dev

# Many of these are installed at runtime if they aren't preinstalled, meaning they're downloaded every time the container starts if you use them
# Preinstalling them prevents that from happening
RUN pip install --use-feature=in-tree-build --root /dist --no-warn-script-location \
    adafruit_circuitpython_mcp230xx gpiod gpiozero \
    pifacecommon pcf8575 pcf8574 adafruit-circuitpython-ads1x15 \
    adafruit-circuitpython-ahtx0 smbus2 RPi.bme280 bme680 w1thermsensor>=2.0.0 \
    pi-ina219 adafruit-mcp3008 pyserial \
    mqtt-io

FROM python:3.9-alpine
COPY --from=builder /dist/ /
CMD [ "python3", "-m", "mqtt_io", "/etc/config.yml" ]
