defmodule Shopify.MultipassTest do
  use ExUnit.Case, async: true

  alias Shopify.Multipass

  describe "get_block_size" do
    test "gets the module attribute" do
      assert is_integer(Multipass.get_block_size())
    end
  end

  describe "get_url/4" do
    test "token is appended" do
      customer_data = %{
        email: "something@test.shopify.com",
        created_at: "2019-03-07T20:29:42.177390Z"
      }

      secret = "1234567890abcdef1234567890abcdef"
      url = Multipass.get_url("myteststore", customer_data, secret)
      info = URI.parse(url)
      assert "myteststore.myshopify.com" == info.host
    end

    test "supports fully customized domains" do
      customer_data = %{
        email: "something@test.shopify.com",
        created_at: "2019-03-07T20:29:42.177390Z"
      }

      secret = "1234567890abcdef1234567890abcdef"
      url = Multipass.get_url("ignored", customer_data, secret, %{host: "myteststore.com"})
      info = URI.parse(url)
      assert "myteststore.com" == info.host
    end
  end

  describe "get_token/3" do
    test "returns token binary with valid input" do
      customer_data = %{
        email: "something@test.shopify.com",
        created_at: "2019-03-07T19:31:23+00:00"
      }

      secret = "1234567890abcdef1234567890abcdef"
      token = Multipass.get_token(customer_data, secret)

      # The message changes because random IVs are generated, but the message length remains the same
      assert byte_size(token) == 172
    end
  end

  describe "pad/2" do
    test "pads string to a byte-size that is a multiple of the block size" do
      block_size = 10
      padded = Multipass.pad("abcd", block_size)
      assert rem(byte_size(padded), block_size) == 0
    end
  end

  describe "encrypt/3" do
    test "encrypted message byte-size is a multiple of the block size" do
      # The :crypto.block_encrypt/4 function will only allow specific block sizes
      block_size = 16
      encryption_key = :crypto.strong_rand_bytes(block_size)

      assert rem(
               byte_size(Multipass.encrypt("Howdy partner", encryption_key, block_size)),
               block_size
             ) == 0
    end
  end

  describe "sign/2" do
    test "signature is appended to message" do
      signature_key = :crypto.strong_rand_bytes(16)
      cipher_text = "1234567890abcdef1234567890abcdef"

      assert "1234567890abcdef1234567890abcdef" <> _signature =
               Multipass.sign(cipher_text, signature_key)
    end
  end

  describe "get_keys/2" do
    test "secret key is separated into 2 keys of equal byte-size" do
      block_size = 16
      {key1, key2} = Multipass.get_keys("1234567890abcdef1234567890abcdef", block_size)
      assert byte_size(key1) == block_size
      assert byte_size(key2) == block_size
    end
  end
end
