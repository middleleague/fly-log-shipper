# Debugging vector transforms

## Local Debugging

Sometimes its useful when tweaking transforms to run it on known input to see whether the output is expected (and get quick feedback on invalid expressions). You can use the vector.toml file in this directory to do so.
```
docker run -d --name=vector -v /$PWD:/tmp/vector:ro -e "VECTOR_CONFIG=/tmp/vector/vector.toml" -p 8686:8686 timberio/vector:0.35.0-debian
```

View logs:
```
docker logs -f vector
```

And stop it when you're done:
```
docker stop vector
docker remove vector
docker rmi timberio/vector:0.35.0-debian
```

You can modify lines and the transform until you get the output you expect.

## Vector Tap

You know what you want. You want to debug in production. Well I just learned about `vector tap` and its exactly what we both want.

From your machine, ssh into a machine running vector that you want to analyze events for:
```
cd cameront/fly-log-shipper
fly ssh console
```

Now tap the input or output that you want to see, e.g.
```
vector tap --outputs-of "nats"
```

And events are streamed to stdout (notifications to stderr). How [neat](https://vector.dev/guides/level-up/vector-tap-guide/)!