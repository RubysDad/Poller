defmodule PollerWeb.VoteController do
  use PollerWeb, :controller

  alias Poller.Polls
  alias Poller.Polls.Vote
  alias PollerWeb.Endpoint

  action_fallback PollerWeb.FallbackController

  def index(conn, _params) do
    votes = Polls.list_votes()
    render(conn, "index.json", votes: votes)
  end

  def create(conn, %{"id" => id, "vote" => %{"option_id" => option_id}}) do
    option = Polls.get_option!(option_id)
    with {:ok, %Vote{} = vote} <- Polls.create_vote(option) do
      Endpoint.broadcast!("poll:" <> id, "new_vote", %{option_id: option.id})

      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end

  def show(conn, %{"id" => id}) do
    vote = Polls.get_vote!(id)
    render(conn, "show.json", vote: vote)
  end

  def update(conn, %{"id" => id, "vote" => vote_params}) do
    vote = Polls.get_vote!(id)

    with {:ok, %Vote{} = vote} <- Polls.update_vote(vote, vote_params) do
      render(conn, "show.json", vote: vote)
    end
  end

  def delete(conn, %{"id" => id}) do
    vote = Polls.get_vote!(id)

    with {:ok, %Vote{}} <- Polls.delete_vote(vote) do
      send_resp(conn, :no_content, "")
    end
  end
end
