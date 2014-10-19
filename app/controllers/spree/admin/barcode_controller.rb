# encoding: utf-8
require 'barby'
require 'prawn'
require 'prawn/measurement_extensions'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
class Spree::Admin::BarcodeController < Spree::Admin::BaseController
  before_filter :load, except: :stickers
  layout :false
  
  # moved to pdf as html has uncontrollable margins
  def print
    pdf = Prawn::Document.new( :page_size => [ 54.mm , 25.mm ] , :margin => 1.mm )

    option_value = " #{@variant.option_values.first.presentation}" if @variant.option_values.first
    name_show = @variant.product.name
    price = @variant.display_price.to_s

    pdf.float do
      pdf.text name_show, align: :left
      pdf.text @variant.barcode, align: :left
    end
    pdf.text option_value, align: :right if option_value
    pdf.text price, align: :right

    if barcode = get_barcode
      pdf.image( StringIO.new( barcode.to_png(:xdim => 5)) , :width => 50.mm , 
            :height => 10.mm , :at => [ 0 , 10.mm])
    end
    send_data pdf.render , :type => "application/pdf" , :filename => "#{name_show}.pdf"
  end

  def stickers
    @stickers = []
    params[:stickers].each do |sticker|
      variant = Spree::Variant.find sticker[:variant].to_i
      barcode_path = create_barcode(variant)
      @stickers << Spree::Sticker.new(variant, sticker[:number].to_i, barcode_path)
    end
    render layout: 'spree/admin/layouts/stickers'
  end
    
  
  private

  #get the barby barcode object from the id, or nil if something goes wrong
  def get_barcode
    code  = @variant.barcode
    return nil if code.to_s.empty?
    ::Barby::Code128B.new( code  )
  end
  
  def load
    @variant = Spree::Variant.find params[:id]
  end

  def create_barcode(variant)
    barcode_path = "/variantsb/#{variant.sku}.png"
    barcode_full_path = "#{Rails.public_path}#{barcode_path}"
    barcode = Barby::Code128B.new(variant.sku)
    File.open(barcode_full_path, 'w'){|f| f.write barcode.to_png }
    return barcode_path
  end

end

