[![Docker Image CI](https://github.com/jjethwa/docker-reticulum/actions/workflows/docker-image.yml/badge.svg)](https://github.com/jjethwa/docker-reticulum/actions/workflows/docker-image.yml)

# docker-reticulum
Docker container running rnsd

## Command line example
```docker run --rm --net=host -v /local/path/to/.reticulum:/home/nonroot/.reticulum -t jordan/reticulum:latest```

## systemd unit
```
[Unit]
Description=reticulum
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker stop reticulum
ExecStartPre=-/usr/bin/docker rm reticulum
ExecStartPre=/usr/bin/docker pull jordan/reticulum:latest
ExecStart=/usr/bin/docker run --net=host --name reticulum -e UMASK_SET=022 -v /path/to/local/.reticulum:/home/nonroot/.reticulum jordan/reticulum:latest

[Install]
WantedBy=multi-user.target
```
## Example config .reticulum/config
```
[reticulum]
  enable_transport = True

  share_instance = Yes

  instance_name = default

  discover_interfaces = Yes

[logging]
  loglevel = 4

[interfaces]

  [[Default Interface]]
    type = AutoInterface
    enabled = Yes
    group_id = reticulum

  [[YOUR TCP INTERFACE]]
    type = TCPClientInterface
    enabled = Yes
    target_host = x.x.x.x
    target_port = 4242
    bootstrap_only = True
```
