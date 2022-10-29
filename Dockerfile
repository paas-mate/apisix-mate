FROM ttbb/apisix:nake

COPY docker-build /opt/apisix/mate

CMD ["/usr/bin/dumb-init", "bash", "-vx", "/opt/apisix/mate/scripts/start.sh"]
