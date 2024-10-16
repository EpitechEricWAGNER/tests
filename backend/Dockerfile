FROM elixir:1.17.3

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app/backend

COPY mix.exs .

RUN mix deps.get

COPY . .

RUN mix deps.compile

EXPOSE 4000

CMD mix setup && mix phx.server
