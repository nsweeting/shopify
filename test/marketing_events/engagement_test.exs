defmodule Shopify.MarketingEventEngagementTest do
  use ExUnit.Case, async: true

  alias Shopify.MarketingEvent.Engagement

  test "client can request to create an engagement" do
    fixture = Fixture.load("../test/fixtures/marketing_events/1/engagements.json", "engagements", [Engagement.empty_resource()])
    assert {:ok, response} = Shopify.session() |> Engagement.create_multiple(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/marketing_events/1/engagements.json", "engagements", [Engagement.empty_resource()])
    assert fixture == response.data
  end
end
