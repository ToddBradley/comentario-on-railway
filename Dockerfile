FROM registry.gitlab.com/comentario/comentario:3.17.0

COPY secrets.template.yaml .
COPY entrypoint.sh .

RUN apk add --no-cache envsubst && chmod +x entrypoint.sh

ENTRYPOINT ["/comentario/entrypoint.sh"]
CMD ["-v"]
