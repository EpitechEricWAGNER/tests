FROM elixir:latest

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB
ARG POSTGRES_HOST

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}
ENV POSTGRES_HOST=${POSTGRES_HOST}

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app/backend

COPY mix.exs .

RUN mix deps.get

RUN mix deps.compile

CMD mix setup && mix phx.server
