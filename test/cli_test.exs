defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1, sort_ascending: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) === :help
    assert parse_args(["--help", "anything"]) === :help
  end

  test "three values returned if three given" do
    assert parse_args(["elixir-lang", "elixir", "3"]) === {"elixir-lang", "elixir", 3}
  end

  test "sort ascending orders the correct way" do
    result = ["c", "a", "b"]
             |> create_map
             |> sort_ascending
             |> extract_from_map

    assert result === ["a", "b", "c"]
  end

  def create_map(values) do
    for value <- values, do:  %{"created_at" => value}
  end

  def extract_from_map(maps) do
    for entry <- maps, do:  Map.get(entry, "created_at")
  end
end
