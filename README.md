# Shopify API

**Currently a Work in Progress**

This package allows Elixir developers to easily access the admin Shopify API. 

## Installation

The package can be installed by adding `shopify` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:shopify, "~> 0.1.6"}]
end
```

## Getting Started

The Shopify API can be accessed in two ways - either with private apps via basic auth, or with oauth.

### Private Apps

Once you have a valid API key and password, setup your `config/confix.exs`.

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

Once you have a shopify app client ID and secret, setup your `config/confix.exs`.

```elixir
config :shopify, [
  client_id: System.get_env("SHOPIFY_CLIENT_ID"),
  client_secret: System.get_env("SHOPIFY_CLIENT_SECRET")
]
```

To gain access to a shop via OAuth, first, generate a permission url based on your requirments.

```elixir
params = %{scope: "read_orders,read_products", redirect_uri: "http://my-redirect_uri.com/"}
permission_url = Shopify.session("shop-name") |> Shopify.OAuth.permission_url(params)
```

After a shop has authorized access, they will be redirected to your URI above. The redirect will include
a payload that contains a 'code'. We can now generate an access token.

```elixir
{:ok, %Shopify.Response{data: oauth}} = Shopify.session("shop-name") |> Shopify.OAuth.request_token(code)
```

We can now easily create a new OAuth API session.

```elixir
Shopify.session("shop-name", oauth.access_token)
```

## Making Requests

All API requests require a session struct to begin.

```elixir
Shopify.session("shop-name", "access-token") |> Shopify.Product.find(1)

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

# Create a resource
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

# Count resources
{:ok, %Shopify.Response{data: count}} = session |> Shopify.Product.count

# Count resources with query params
{:ok, %Shopify.Response{data: count}} = session |> Shopify.Product.count(%{vendor: "Fancy Vendor"})

# Search for resources
{:ok, %Shopify.Response{data: customers}} = session |> Shopify.Customer.search(%{query: "country:United States"})

# Delete a resource
{:ok, _} = session |> Shopify.Product.delete(id)
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
```

The `%Shopify.Response{}` struct contains two fields: code and data. Code is the HTTP
status code that is returned from Shopify. A successful request will either set the data field
with a single struct, or list of structs of the resource or resources requested.

## Current Resources

- Address
- ApplicationCharge (find, all, create, activate)
- ApplicationCredit (find, all, create)
- Attribute
- BillingAddress
- Blog (find, all, create, update, delete, count)
- CarrierService (find, all, create, update, delete)
- Checkout (all, count)
- ClientDetails
- Collect (find, all, create, delete, count)
- CollectionListing (find, all)
- CustomCollection (find, all, create, update, delete, count)
- Customer (find, all, create, update, delete, count, search)
- CustomerAddress (find, all, create, delete)
- DiscountCode
- Fullfillment
- Image (ProductImage) (find, all, create, update, delete, count)
- LineItem
- Option
- Order (find, all, create, update, delete, count)
- PaymentDetails
- Product (find, all, create, update, delete, count)
- RecurringApplicationCharge (find, all, create, activate, delete)
- ScriptTag (find, all, create, count, delete)
- ShippingAddress
- ShippingLine
- Shop (current)
- TaxLine
- Transaction (find, all, create, count)
- UsageCharge (find, all, create)
- Variant
- Webhook (find, all, create, update, delete, count)

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
They can be found at [https://hexdocs.pm/shopify](https://hexdocs.pm/shopify).
