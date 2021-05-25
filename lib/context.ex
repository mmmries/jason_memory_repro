defmodule Context do
  defstruct connector_fields: %{},
            custom_fields: %{},
            external_id: nil,
            mapping_id: nil,
            meta: %{},
            normalized_fields: %{}
end

defimpl Jason.Encoder, for: Context do
  def encode(%Context{meta: meta}, opts) do
    Jason.Encode.map(meta, opts)
  end
end
