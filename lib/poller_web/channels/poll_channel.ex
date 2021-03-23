defmodule Poller.PollChannel do
  use PollerWeb, :channel

  def join("poll:" <> _poll_id, _payload, socket) do
    {:ok, socket}
  end
end
