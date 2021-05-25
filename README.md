# Reproduction of Jason Memory spike

Please see https://github.com/michalmuskala/jason/issues/134 for details of the original issue.
This repo is an attempt to reproduce a situation I'm seeing in a production system where
a piece of dynamic trace data has a json binary representation that is ~825MB,
but serializing it ends up allocating over 2.5GB of memory.

This repository uses a smaller example that I think shows a similar issue.
After cloning this repo you can run:

```
$ mix deps.get
$ mix run repro.exs
```

This generates a pseudo-random set of data that has many duplicated sub-trees and uses lots of structs that only encode a small portion of their data into the final json.

* The `:erts_debug.flat_size` is ~25MB
* The `Jason.encode_to_iodata() |> :erts_debug.flat_size` is ~204MB
* Calling `Jason.encode!` uses more than 650MB of data at it's peak