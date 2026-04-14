FROM registry.gitlab.com/comentario/comentario

COPY secrets.template.yaml .

RUN apk add --no-cache envsubst

ARG POSTGRES_HOST
ARG POSTGRES_PORT
ARG POSTGRES_DATABASE
ARG POSTGRES_USERNAME
ARG POSTGRES_PASSWORD

# Add these new ARGs for SMTP
ARG SMTP_HOST
ARG SMTP_PORT
ARG SMTP_USERNAME
ARG SMTP_PASSWORD
ARG SMTP_FROM_ADDRESS

RUN envsubst < secrets.template.yaml > secrets.yaml
