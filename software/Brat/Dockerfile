FROM python:3-slim
MAINTAINER James A Sutherland <j@sutherland.pw>
USER nobody
EXPOSE 1080
ADD  brat /brat
ADD brat-setup.sh /
RUN /brat-setup.sh
ENTRYPOINT [ "/brat/standalone.py", "1080" ]
