FROM scratch
COPY dimensional-lumber /usr/bin/dimensional-lumber
ENTRYPOINT ["/usr/bin/dimensional-lumber"]