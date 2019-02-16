defmodule Discuss.Plugs.SetUser do
  use Discuss.Web, :plug

  alias Discuss.User

  def init(_params) do # is run once, then it's result is sent to the subsequent `call` calls
  end

  def call(conn, _params) do # params is the value returned from the `init` function
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end

end
