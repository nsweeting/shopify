defmodule Shopify.ReportTest do
  use ExUnit.Case, async: true

  alias Shopify.Report

  test "client can request a single report" do
    assert {:ok, response} = Shopify.session() |> Report.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/reports/1.json", "report", Report.empty_resource())
    assert fixture == response.data
  end

  test "client can request all reports" do
    assert {:ok, response} = Shopify.session() |> Report.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/reports.json", "reports", [Report.empty_resource()])
    assert fixture == response.data
  end

  test "client can request to create a report" do
    fixture = Fixture.load("../test/fixtures/reports/1.json", "report", Report.empty_resource())
    assert {:ok, response} = Shopify.session() |> Report.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/reports/1.json", "report", Report.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update a report" do
    assert {:ok, response} = Shopify.session() |> Report.find(1)
    assert "Wholesale Sales Report" == response.data.name
    update = %{response.data | name: "Update"}
    assert {:ok, response} = Shopify.session() |> Report.update(1, update)
    assert "Update" == response.data.name
  end

  test "client can request to patch update a report" do
    update = %{name: "Update"}
    assert {:ok, response} = Shopify.session() |> Report.patch_update(1, update)
    assert "Update" == response.data.name
  end

  test "client can request to delete a report" do
    assert {:ok, response} = Shopify.session() |> Report.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
