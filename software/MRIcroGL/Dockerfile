FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -yq wget curl qtcreator unzip libqt5x11extras5
RUN wget https://github.com/davidbannon/libqt5pas/releases/download/v1.2.9/libqt5pas1_2.9-0_amd64.deb
RUN wget https://github.com/davidbannon/libqt5pas/releases/download/v1.2.9/libqt5pas-dev_2.9-0_amd64.deb
RUN dpkg -i libqt5pas1_2.9-0_amd64.deb libqt5pas-dev_2.9-0_amd64.deb
RUN wget https://github.com/rordenlab/MRIcroGL/releases/download/v1.2.20220720/MRIcroGL_linux.zip
RUN unzip MRIcroGL_linux.zip
CMD ["MRIcroGL/MRIcroGL_QT"]
