big_list = Enum.map(1..5000, fn(i) ->
  %Context{
    meta: %{record_type: "Deal", record_id: 100 + i},
    custom_fields: %{
      "foo" => :crypto.strong_rand_bytes(48),
      "bar" => :crypto.strong_rand_bytes(48),
      "bazimuth" => :crypto.strong_rand_bytes(48)
    },
    external_id: :crypto.strong_rand_bytes(48),
    mapping_id: 200 + i,
    normalized_fields: %{
      "uuid" => :crypto.strong_rand_bytes(48),
      "name" => :crypto.strong_rand_bytes(48),
      "label" => :crypto.strong_rand_bytes(48)
    }
  }
end)

trace = Enum.map(1..100, fn(i) ->
  %{
    value: big_list,
    parts: [
      %{source_type: "Scope", source_id: 300 + i, offset: [0, 25]}
    ]
  }
end)

# set the maximum process memory
max_heap_words = div(floor(650 * 1024 * 1024), :erlang.system_info(:wordsize))
Process.flag(:max_heap_size, max_heap_words)

# check size of data
div(Process.info(self(), :memory) |> elem(1), 1024 * 1024) |> IO.inspect(label: "mem initial (mb)")
div(trace |> :erts_debug.flat_size(), 1024 * 1024) |> IO.inspect(label: "trace flat_size (mb)")
div(trace |> Jason.encode_to_iodata!() |> :erts_debug.flat_size(), 1024 * 1024) |> IO.inspect(label: "encode_to_io_data flat_size (mb)")
div(Process.info(self(), :memory) |> elem(1), 1024 * 1024) |> IO.inspect(label: "mem after encode_to_iodata! (mb)")

# try to encode to binary
div(trace |> Jason.encode!() |> byte_size(), 1024 * 1024) |> IO.inspect(label: "encode! byte_size (mb)")
div(Process.info(self(), :memory) |> elem(1), 1024 * 1024) |> IO.inspect(label: "mem after encode! (mb)")
