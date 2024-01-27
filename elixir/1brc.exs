# Stream the file into a concurrent map

# File.stream!("../../measurements.txt")
File.stream!("../1M.txt")
|> Stream.map(&String.split(&1, ";"))
|> Stream.map(fn [k, v] -> {k, String.to_float(String.trim(v))} end)
|> Stream.into([])
|> Enum.reduce(%{}, fn {k, v}, acc ->
  Map.get_and_update(acc, k, fn
    {count, min, max, sum} ->
      IO.puts("Updating #{k} with #{v}")
      {{count, min, max, sum}, {count + 1, min(v, min), max(v, max), sum + v}}

    nil ->
      {nil, {1, v, v, v}}
  end)

  acc
end)
|> IO.inspect()
