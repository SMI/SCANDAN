FROM ubuntu:24.04
ARG debian_frontend=noninteractive
ENV TZ=Europe/London
RUN apt update && apt install -y unzip libgtk2.0-bin
COPY MRIcron_linux.zip .
RUN unzip MRIcron_linux.zip
ENTRYPOINT [ "/mricron/MRIcron" ]
