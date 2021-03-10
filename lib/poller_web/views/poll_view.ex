defmodule PollerWeb.PollView do
  use PollerWeb, :view
  alias PollerWeb.{PollView, OptionView}

  def render("index.json", %{polls: polls}) do
    %{data: render_one(polls, PollView, "poll_with_options.json")}
  end

  def render("poll_with_options.json", %{poll: poll}) do
    %{
      id: poll.id,
      question: poll.question,
      options: render_many(poll.options, OptionView, "option.json")
    }
  end

  def render("show.json", %{poll: poll}) do
    %{data: render_one(poll, PollView, "poll.json")}
  end

  def render("poll.json", %{poll: poll}) do
    %{id: poll.id,
      question: poll.question}
  end
end
