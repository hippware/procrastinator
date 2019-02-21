defmodule Dawdle.HandlerTest do
  use ExUnit.Case

  alias Dawdle.Client

  defmodule TestEvent do
    defstruct [:pid]
  end

  defmodule TestHandler do
    use Dawdle.Handler, types: [TestEvent]

    def handle_event(%TestEvent{} = event) do
      send(event.pid, :handled)
      :ok
    end
  end

  setup_all do
    Client.clear_all_subscriptions()
    TestHandler.register()

    :ok
  end

  test "basic event handler" do
    t = %TestEvent{pid: self()}

    Dawdle.signal(t)

    assert_receive :handled
  end
end