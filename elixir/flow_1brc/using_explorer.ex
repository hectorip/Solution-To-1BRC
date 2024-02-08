Mix.install([
  {:explorer, "~> 0.8.0"}
])



defmodule WithExplorer do
  # Results
  # [
    # 1_000_000_000: 675483.000ms,
    #   500_000_000: 58244.713ms,
    #   100_000_000: 10321.046ms,
    #    50_000_000: 5104.949ms,
  # ]
  require Explorer.DataFrame
  alias Explorer.{DataFrame, Series}

  @filename "../../../measurements.txt"

  def run() do
    _parent = self()

    results = @filename
    |> DataFrame.from_csv!(header: false, delimiter: ";", eol_delimiter: "\n")
    |> DataFrame.group_by("column_1")
    |> DataFrame.summarise(min: Series.min(column_2), mean: Series.mean(column_2), max: Series.max(column_2))
    |> DataFrame.arrange(column_1)

     for idx <- 0..(results["column_1"] |> Series.to_list() |> length() |> Kernel.-(1)) do
       "#{results["column_1"][idx]}=#{results["min"][idx]}/#{:erlang.float_to_binary(results["mean"][idx], decimals: 2)}/#{results["max"][idx]}"
     end
  end
end

IO.puts(WithExplorer.run())

