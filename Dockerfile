FROM elixir:1.6.6 as edep
WORKDIR /code
COPY . .
RUN mix local.hex --force

FROM openwhisk/python2action as ndep
WORKDIR /code
RUN apk add nodejs npm
COPY --from=edep /code .
RUN cd assets && npm install

FROM elixir:1.6.6 
WORKDIR /code
RUN apt update -y
RUN apt install -y nodejs npm python2 inotify-tools
COPY --from=ndep /code .
RUN mix local.hex --force   
CMD ["mix", "phx.server"]
