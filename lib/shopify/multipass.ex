defmodule Shopify.Multipass do
  @moduledoc """
  SSO Logins can be accomplished by enabling the Multipass feature on your Shopify Plus account.
  This requires the use of a special Multipass session token.
  [https://help.shopify.com/en/api/reference/plus/multipass](https://help.shopify.com/en/api/reference/plus/multipass)
  """

  # The size of the crypto used by http://erlang.org/doc/man/crypto.html#block_encrypt-4
  # Refer to the erlang docs as to which block sizes are allowed
  @block_size 16

  @doc ~S"""
  Simple getter to expose the module attribute
  """
  def get_block_size(), do: @block_size

  @doc ~S"""
  Get the full URL for the Multipass signin.

  ## Examples
    iex> customer_data = %{
    ...>     email: "something@test.shopify.com",
    ...>     created_at: "2019-03-07T20:29:42.177390Z"
    ...>   }
    %{
    created_at: "2019-03-07T20:29:42.177390Z",
    email: "something@test.shopify.com"
    }
    iex> secret = "1234567890abcdef1234567890abcdef"
    "1234567890abcdef1234567890abcdef"
    iex>  url = Shopify.Multipass.get_url("myteststore", customer_data, secret)
    "https://myteststore.myshopify.com/account/login/multipass/moaqEVx1Yu9hsvYvVpj-LeRYDtOo6ikicfTZd8tR8-xBMRg8tFjGEfllEcjj2VdbsezmT0XuEdglyQzi_biQPkfLJnP1dkxhNtfzwtt6IMQzu3W0qCPzbrUMD_gLaytPVP-zZZuYiSBqEMNdvzFg3zf0TOQHwbizX2D7It02sFI7ZpTRhfX4m_crV0b-DmmF"
    iex>  url = Shopify.Multipass.get_url("", customer_data, secret, %{host: "custom-domain.com")
    "https://custom-domain.com/account/login/multipass/moaqEVx1Yu9hsvYvVpj-LeRYDtOo6ikicfTZd8tR8-xBMRg8tFjGEfllEcjj2VdbsezmT0XuEdglyQzi_biQPkfLJnP1dkxhNtfzwtt6IMQzu3W0qCPzbrUMD_gLaytPVP-zZZuYiSBqEMNdvzFg3zf0TOQHwbizX2D7It02sFI7ZpTRhfX4m_crV0b-DmmF"
  """
  @spec get_url(binary, map, binary, map) :: binary
  def get_url(shop_name, customer_data, multipass_secret, options \\ %{}) do
    struct(
      %URI{
        host: "#{shop_name}.myshopify.com",
        path: "/account/login/multipass/#{get_token(customer_data, multipass_secret)}",
        port: 443,
        scheme: "https"
      },
      options
    )
    |> URI.to_string()
  end

  @doc ~S"""
  Calculates the Shopify Multipass token: an encrypted and signed message containing the customer data to be used for
  the Multipass SSO.
  """
  @spec get_token(map, binary) :: binary
  def get_token(customer_data, multipass_secret) do
    {encryption_key, signature_key} = get_keys(multipass_secret)

    Poison.encode!(customer_data)
    |> encrypt(encryption_key)
    |> sign(signature_key)
    |> Base.url_encode64(case: :lower)
  end

  @doc ~S"""
  Pads the message string with extra bytes to ensure it is evenly divisible by
  the block size.
  See [http://erlang.org/doc/man/crypto.html#block_encrypt-4](http://erlang.org/doc/man/crypto.html#block_encrypt-4)
  """
  @spec pad(binary, integer) :: binary
  def pad(string, block_size \\ @block_size) do
    to_add = block_size - rem(byte_size(string), block_size)
    string <> :binary.copy(<<to_add>>, to_add)
  end

  @doc ~S"""
  Encrypts a message using the given encryption key. This will pad the message according to the block size.
  Returns the encrypted message as cipher text.
  """
  @spec encrypt(binary, binary, integer) :: binary
  def encrypt(message, encryption_key, block_size \\ @block_size) do
    initialization_vector = :crypto.strong_rand_bytes(block_size)

    initialization_vector <>
      :crypto.block_encrypt(
        :aes_cbc128,
        encryption_key,
        initialization_vector,
        pad(message, block_size)
      )
  end

  @doc ~S"""
  Signs the given cipher text message using the provided signature key
  """
  @spec sign(binary, binary) :: binary
  def sign(cipher_text, signature_key) do
    signature = :crypto.hmac(:sha256, signature_key, cipher_text)
    cipher_text <> signature
  end

  @doc ~S"""
  Splits the multipass secret into 2 binaries, each containing exactly the block size number of bytes.
  Returns a tuple where the first item is the encryption_key, the second is the signature_key
  """
  @spec get_keys(binary, integer) :: tuple
  def get_keys(multipass_secret, block_size \\ @block_size) do
    key_material = :crypto.hash(:sha256, multipass_secret)
    # Split the key into 2 binaries each containing exactly 16 bytes
    <<encryption_key::binary-size(block_size), signature_key::binary-size(block_size)>> =
      key_material

    {encryption_key, signature_key}
  end
end
