defmodule Issues.CLI do
  import Issues.TableFormatter, only: [ print_table_for_columns: 2 ]

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args
    |> _process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """

  def parse_args(argv) do
    case OptionParser.parse(argv, switches: [ help: :boolean], aliases: [ h: :help]) do
    { [ help: true ], _, _ }            -> :help
    { _, [ user, project, count ], _ }  -> { user, project, String.to_integer(count) }
    { _, [ user, project ], _ }         -> { user, project, @default_count }
    _                                   -> :help
    end
  end

  defp _process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt()
  end

  defp _process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> _decode_response
    |> sort_ascending
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  defp _decode_response({:ok, body}), do: body

  defp _decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def sort_ascending(list_of_issues) do
    Enum.sort list_of_issues,
              fn i1, i2 -> Map.get(i1, "created_at") <= Map.get(i2, "created_at") end
  end

end
