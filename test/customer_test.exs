defmodule Shopify.CustomerTest do
  use ExUnit.Case, async: true

  alias Shopify.{
    Customer,
    CustomerInvite
  }

  test "client can request a single customer" do
    assert {:ok, response} = Shopify.session() |> Customer.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers/1.json", "customer", Customer.empty_resource())
    assert fixture == response.data
  end

  test "client can request all customers" do
    assert {:ok, response} = Shopify.session() |> Customer.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers.json", "customers", [Customer.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a customer count" do
    assert {:ok, response} = Shopify.session() |> Customer.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a customer" do
    fixture = Fixture.load("../test/fixtures/customers/1.json", "customer", Customer.empty_resource())
    assert {:ok, response} = Shopify.session() |> Customer.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers/1.json", "customer", Customer.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update a customer" do
    assert {:ok, response} = Shopify.session() |> Customer.find(1)
    assert "Bob" == response.data.first_name
    update = %{response.data | first_name: "Update"}
    assert {:ok, response} = Shopify.session() |> Customer.update(1, update)
    assert "Update" == response.data.first_name
  end

  test "client can request to delete a customer" do
    assert {:ok, response} = Shopify.session() |> Customer.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  test "client can request a customer's orders" do
    assert {:ok, response} = Shopify.session() |> Customer.orders(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers/1/orders.json", "orders", [Customer.Order.empty_resource()])
    assert fixture == response.data
  end

  test "client can send an invite to customer" do
    assert {:ok, response} = Shopify.session() |> Customer.send_invite(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers/1/send_invite.json", "customer_invite", CustomerInvite.empty_resource())
    assert fixture == response.data
  end

  test "client can send a custom invite to customer" do
    customer_invite = %CustomerInvite{
      to: "new_test_email@shopify.com",
      from: "noaccesssteve@jobs.com",
      bcc: [
        "noaccesssteve@jobs.com"
      ],
      subject: "Welcome to my new shop",
      custom_message: "My awesome new store"
    }
    assert {:ok, response} = Shopify.session() |> Customer.send_invite(1, customer_invite)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert customer_invite == response.data
  end

  test "client can create an account activation" do
    assert {:ok, response} = Shopify.session() |> Customer.account_activation_url(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customers/1/account_activation_url.json", "account_activation_url", %{})
    assert fixture == response.data
  end
end
