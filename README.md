# Shopify API

[![Build Status](https://travis-ci.org/nsweeting/shopify.svg?branch=master)](https://travis-ci.org/nsweeting/shopify)
[![Hex.pm](https://img.shields.io/hexpm/v/shopify.svg)](https://hex.pm/packages/shopify)

This package allows Elixir developers to easily access the admin Shopify API.

## Installation

The package can be installed by adding `shopify` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:shopify, "~> 0.4"}]
end
```

## Getting Started

The Shopify API can be accessed in two ways - either with private apps via basic auth, or with oauth.

### Private Apps

Once you have a valid API key and password, setup your `config/config.exs`.

```elixir
config :shopify, [
  shop_name: "my-shop",
  api_key: System.get_env("SHOPIFY_API_KEY"),
  password: System.get_env("SHOPIFY_API_PASSWORD")
]
```

We can now easily create a new API session.

```elixir
Shopify.session
```

Alternatively, we can create a one-off session.

```elixir
Shopify.session("my-shop-name", "my-api-key", "my-password")
```

### OAuth Apps

Once you have a shopify app client ID and secret, setup your `config/config.exs`.

```elixir
config :shopify, [
  client_id: System.get_env("SHOPIFY_CLIENT_ID"),
  client_secret: System.get_env("SHOPIFY_CLIENT_SECRET")
]
```

To gain access to a shop via OAuth, first, generate a permission url based on your requirments.

```elixir
params = %{scope: "read_orders,read_products", redirect_uri: "http://my-redirect_uri.com/"}
permission_url = "shop-name" |> Shopify.session() |> Shopify.OAuth.permission_url(params)
```

After a shop has authorized access, they will be redirected to your URI above. The redirect will include
a payload that contains a 'code'. We can now generate an access token.

```elixir
{:ok, %Shopify.Response{data: oauth}} = "shop-name" |> Shopify.session() |> Shopify.OAuth.request_token(code)
```

We can now easily create a new OAuth API session.

```elixir
Shopify.session("shop-name", oauth.access_token)
```

## Making Requests

All API requests require a session struct to begin.

```elixir
"shop-name" |> Shopify.session("access-token") |> Shopify.Product.find(1)

# OR

session = Shopify.session("shop-name", "access-token")
Shopify.Product.find(session, 1)
```

Here are some examples of the various types of requests that can be made.

```elixir
# Create a session struct
session = Shopify.session("shop-name", "access-token")

# Find a resource by ID
{:ok, %Shopify.Response{data: product}} = session |> Shopify.Product.find(id)

# Find a resource and select fields
{:ok, %Shopify.Response{data: product}} = session |> Shopify.Product.find(id, %{fields: "id,images,title"})

# All resources
{:ok, %Shopify.Response{data: products}} = session |> Shopify.Product.all

# All resources with query params
{:ok, %Shopify.Response{data: products}} = session |> Shopify.Product.all(%{page: 1, limit: 5})

# Find a resource and update it
{:ok, %Shopify.Response{data: product}} = session |> Shopify.Product.find(id)
updated_product = %{product | title: "New Title"}
{:ok, response} = session |> Shopify.Product.update(product.id, updated_product)

# Update a resource without finding it
{:ok, response} = session |> Shopify.Product.update(id, %{title: "New Title"})

# Create a resource from the resource struct
new_product = %Shopify.Product{
    title: "Fancy Shirt",
    body_html: "<strong>Good shirt!<\/strong>",
    vendor: "Fancy Vendor",
    product_type: "shirt",
    variants: [
    	%{
   		price: "10.00",
    		sku: 123
   	}]
    }
{:ok, response} = session |> Shopify.Product.create(new_product)

# Create a resource from a simple map
new_product_args = %{
    title: "Fancy Shirt",
    body_html: "<strong>Good shirt!<\/strong>",
    vendor: "Fancy Vendor",
    product_type: "shirt",
    variants: [
    	%{
   		price: "10.00",
    		sku: 123
   	}]
    }
{:ok, response} = session |> Shopify.Product.create(new_product_args)

# Count resources
{:ok, %Shopify.Response{data: count}} = session |> Shopify.Product.count

# Count resources with query params
{:ok, %Shopify.Response{data: count}} = session |> Shopify.Product.count(%{vendor: "Fancy Vendor"})

# Search for resources
{:ok, %Shopify.Response{data: customers}} = session |> Shopify.Customer.search(%{query: "country:United States"})

# Delete a resource
{:ok, _} = session |> Shopify.Product.delete(id)
```

## API Versioning

Shopify supports [API versioning](https://help.shopify.com/en/api/versioning). By
default, if you dont specify an api version, your request defaults to the oldest
supported stable version.

You can specify a default version through application config.

```elixir
config :shopify, [
  api_version: "2019-04"
]
```

You can also set a specific version per session.

```elixir
Shopify.session("shop-name", "access-token") |> Shopify.Session.put_api_version("2019-04")
```

## Handling Responses

Responses are all returned in the form of a two-item tuple. Any response that has a status
code below 300 returns `{:ok, response}`. Codes above 300 are returned as `{:error, response}`.

```elixir
# Create a session struct
session = Shopify.session("shop-name", "access-token")

# 'data' is returned as a %Shopify.Product struct
{:ok, %Shopify.Response{code: 200, data: data}} = session |> Shopify.Product.find(id)

# 'data' is returned as a list of %Shopify.Product structs
{:ok, %Shopify.Response{code: 200, data: data}} = session |> Shopify.Product.all

# 'message' is a text description of the error.
{:error, %Shopify.Response{code: 404, data: message}} = session |> Shopify.Product.find(1)

# Failed requests return %Shopify.Error struct
{:error, %Shopify.Error{reason: :econnrefused, source: :httpoison}} = session |> Shopify.Product.find(1)

```

The `%Shopify.Response{}` struct contains two fields: code and data. Code is the HTTP
status code that is returned from Shopify. A successful request will either set the data field
with a single struct, or list of structs of the resource or resources requested.

## Multipass

The [Multipass](https://help.shopify.com/en/api/reference/plus/multipass) is available to Shopify Plus plans. It allows your non-Shopify site to be the source of truth for authentication and login. After your site has successfully authenticated a user, redirect their browser to Shopify using the special Multipass URL: this will upsert the customer data in Shopify and log them in.

Unlike other API requests, this does not require a session: it relies on a shared secret to do decryption.

Your customer data must at a minimum provide an email address and a current datetime in 8601 format.

```elixir
customer_data = %{
  email: "something@test.shopify.com",
  created_at: DateTime.to_iso8601(Timex.now())
}

# From your store's checkout settings
multipass_secret = Application.get_env("MULTIPASS_SECRET")

url = Shopify.Multipass.get_url("myteststore", customer_data, multipass_secret)

# Redirect the browser immediately to the resulting URL:
"https://myteststore.myshopify.com/account/login/multipass/moaqEVx1Yu9hsvYvVpj-LeRYDtOo6ikicfTZd8tR8-xBMRg8tFjGEfllEcjj2VdbsezmT0XuEdglyQzi_biQPkfLJnP1dkxhNtfzwtt6IMQzu3W0qCPzbrUMD_gLaytPVP-zZZuYiSBqEMNdvzFg3zf0TOQHwbizX2D7It02sFI7ZpTRhfX4m_crV0b-DmmF"
```

## Testing

For testing a mock adapter can be configured to use fixture json files instead of doing real requests.

Lets say you have a test config file in `your_project/config/test.exs` and tests in `your_project/test` you could use this configuration:

```elixir
# your_project/config/test.exs
config :shopify, [
  shop_name: "test",
  api_key: "test-key",
  password: "test-password",
  client_secret: "test-secret",
  client_adapter: Shopify.Adapters.Mock, # Use included Mock adapter
  fixtures_path: Path.expand("../test/fixtures/shopify", __DIR__) # Use fixures in this directory
]
```

When using oauth, make sure the token passed is `test`, otherwise authentication will fail.

```elixir
Shopify.session("my-shop.myshopify.com", "test")
|> Product.all()
```

### Test Adapter

This plugin provides a test adapter called `Shopify.Adapters.Mock` to use out of the box. It makes certain assumptions about your fixtures and is limited to the responses provided in corresponding fixture files, and for create actions it will put the resource id as 1.

If you would like to roll your own adapter, you can do so by implementing `@behaviour Shopify.Adapters.Base`.

```elixir
defmodule Shopify.Adapters.Mock do
  @moduledoc false

  @behaviour Shopify.Adapters.Base

  def get(%Shopify.Request{} = request) do
    data =  %{resource: %{id: 123, attribute: "attribute"}}
    {:ok,  %Shopify.Response{code: 200, data: data}}
  end

  # ...
end
```

### Fixtures

Fixture files must follow a certain structure, so the adapter is able to find them. If your resource is `Shopify.Product.all()` you need to provide a file at `path_you_provided_in_config/products.json` and must include a valid response json

```
{
  "orders": [
    {
      "buyer_accepts_marketing": false,
      "cancel_reason": null,
      "cancelled_at": null,
      ...
    }
  ]
}
```

Or for `Shopify.Product.find(1)`

```
# path_you_provided_in_config/products/1.json
{
  "order": {
    "id": 1,
    "email": "bob.mctest@test.com",
    ...
  }
}
```

## Current Resources

- Address
- ApplicationCharge (find, all, create, activate)
- ApplicationCredit (find, all, create)
- Article (find, all, create, update, delete, count)
- Article.Author (all)
- Article.Tag (all)
- Attribute
- BillingAddress
- Blog (find, all, create, update, delete, count)
- CarrierService (find, all, create, update, delete)
- Checkout (all, find, create, update, count, shipping_rates, complete, count)
- ClientDetails
- Collect (find, all, create, delete, count)
- CollectionListing (find, all)
- Comment (find, all, create, update, spam, not_spam, approve, remove, restore)
- Country (find, all, create, update, delete, count)
- Country.Province (find, all, update, count)
- CustomCollection (find, all, create, update, delete, count)
- Customer (find, all, create, update, delete, count, search)
- CustomerAddress (find, all, create, delete)
- CustomerSavedSearch (find, all, create, update, delete, count)
- CustomerSavedSearch.Customer (all)
- DiscountCode
- DraftOrder (find, all, create, update, delete, count, complete, send_invoice) *`send_invoice` is an alias of `DraftOrder.DraftOrderInvoice.create/3`*
- DraftOrder.DraftOrderInvoice (create)
- MarketingEvent.Engagement (create_multiple)
- Event (find, all, count)
- Order.Fullfillment (find, all, count, create, update, complete, open, cancel)
- Order.Fullfillment.Event (find, all, delete)
- FulfillmentService (find, all, create, update, delete)
- Image (ProductImage) (find, all, create, update, delete, count)
- InventoryLevel (all, delete)
- LineItem
- Location (find, all, count)
- MarketingEvent (find, all, count, create, update, delete, create_multiple_engagements) *`create_multiple_engagements` is an alias of `MarketingEvent.Engagement.create_multiple/3`*
- Metafield
- OAuth.AccessScope (all)
- Option
- Order (find, all, create, update, delete, count)
- Order.Event (all)
- Order.Risk (create, find, all, update, delete)
- Page (create, find, all, update, delete, count)
- PaymentDetails
- Policy (all)
- PriceRule (find, all, create, update, delete)
- PriceRule.DiscountCode (find, all, create, update, delete)
- Product (find, all, create, update, delete, count)
- Product.Event (all)
- ProductListing (find, all, create, update, delete, count, product_ids)
- RecurringApplicationCharge (find, all, create, activate, delete)
- Redirect (find, all, create, update, delete, count)
- Refund (create, find, all)
- Report (create, find, all, update, delete)
- ScriptTag (find, all, create, count, delete)
- ShippingAddress
- ShippingLine
- Shop (current)
- SmartCollection (find, all, create, count, update, delete)
- TaxLine
- Theme (find, all, create, update, delete)
- Theme.Asset (find, all, delete)
- Transaction (find, all, create, count)
- UsageCharge (find, all, create)
- Variant (find, all, create, update, delete, count)
- Webhook (find, all, create, update, delete, count)

## Contributors

<!-- Contributors START
Nick_Sweeting nsweeting https://github.com/nsweeting code prReview doc infra
Marcelo_Oliveira overallduka https://github.com/overallduka code
Fabian_Zitter Ninigi https://github.com/Ninigi code prReview doc
Zach_Garwood zachgarwood https://github.com/zachgarwood code
David_Becerra DavidVII https://github.com/DavidVII code
Bryan_Bryce BryanJBryce https://github.com/BryanJBryce doc
humancopy humancopy https://github.com/humancopy code
Contributors END -->
<!-- Contributors table START -->
| <img src="https://avatars.githubusercontent.com/nsweeting?s=100" width="100" alt="Nick Sweeting" /><br />[<sub>Nick Sweeting</sub>](https://github.com/nsweeting)<br />[💻](git@github.com:nsweeting/shopify/commits?author=nsweeting) 👀 [📖](git@github.com:nsweeting/shopify/commits?author=nsweeting) 🚇 | <img src="https://avatars.githubusercontent.com/overallduka?s=100" width="100" alt="Marcelo Oliveira" /><br />[<sub>Marcelo Oliveira</sub>](https://github.com/overallduka)<br />[💻](git@github.com:nsweeting/shopify/commits?author=overallduka) | <img src="https://avatars.githubusercontent.com/Ninigi?s=100" width="100" alt="Fabian Zitter" /><br />[<sub>Fabian Zitter</sub>](https://github.com/Ninigi)<br />[💻](git@github.com:nsweeting/shopify/commits?author=Ninigi) 👀 [📖](git@github.com:nsweeting/shopify/commits?author=Ninigi) | <img src="https://avatars.githubusercontent.com/zachgarwood?s=100" width="100" alt="Zach Garwood" /><br />[<sub>Zach Garwood</sub>](https://github.com/zachgarwood)<br />[💻](git@github.com:nsweeting/shopify/commits?author=zachgarwood) | <img src="https://avatars.githubusercontent.com/DavidVII?s=100" width="100" alt="David Becerra" /><br />[<sub>David Becerra</sub>](https://github.com/DavidVII)<br />[💻](git@github.com:nsweeting/shopify/commits?author=DavidVII) | <img src="https://avatars.githubusercontent.com/BryanJBryce?s=100" width="100" alt="Bryan Bryce" /><br />[<sub>Bryan Bryce</sub>](https://github.com/BryanJBryce)<br />[📖](git@github.com:nsweeting/shopify/commits?author=BryanJBryce) | <img src="https://avatars.githubusercontent.com/humancopy?s=100" width="100" alt="humancopy" /><br />[<sub>humancopy</sub>](https://github.com/humancopy)<br />[💻](git@github.com:nsweeting/shopify/commits?author=humancopy) | <img src="https://avatars.githubusercontent.com/Cmeurer10?s=100" width="100" alt="Cmeurer10" /><br />[<sub>Cmeurer10</sub>](https://github.com/Cmeurer10)<br />[💻](git@github.com:nsweeting/shopify/commits?author=Cmeurer10) | <img src="https://avatars.githubusercontent.com/lewisf?s=100" width="100" alt="lewisf" /><br />[<sub>lewisf</sub>](https://github.com/lewisf)<br />[💻](git@github.com:nsweeting/shopify/commits?author=lewisf) | <img src="https://avatars.githubusercontent.com/vladimir-e?s=100" width="100" alt="vladimir-e" /><br />[<sub>vladimir-e</sub>](https://github.com/vladimir-e)<br />[💻](git@github.com:nsweeting/shopify/commits?author=vladimir-e) | <img src="https://avatars.githubusercontent.com/furqanaziz?s=100" width="100" alt="furqanaziz" /><br />[<sub>furqanaziz</sub>](https://github.com/furqanaziz)<br />[💻](git@github.com:nsweeting/shopify/commits?author=furqanaziz) | <img src="https://avatars.githubusercontent.com/balexand?s=100" width="100" alt="balexand" /><br />[<sub>balexand</sub>](https://github.com/balexand)<br />[💻](git@github.com:nsweeting/shopify/commits?author=balexand)
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |

<!-- Contributors table END -->
This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification.

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
They can be found at [https://hexdocs.pm/shopify](https://hexdocs.pm/shopify).
