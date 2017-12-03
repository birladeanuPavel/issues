defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir"} ]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    _issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> _handle_response
  end

  defp _issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  defp _handle_response({ :ok, %{status_code: 200, body: body}}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  defp _handle_response({ _, %{status_code: _, body: body}}) do
    { :error, Poison.Parser.parse!(body) }
  end

end
