Spree::Sticker = Struct.new(:variant, :number, :barcode_path) do
  def times
    number.times
  end
end