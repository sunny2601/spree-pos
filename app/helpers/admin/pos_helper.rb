module Admin::PosHelper

  def admin_pos_variants_path
    "/admin/pos/find"
  end
  
  def item_total
    sum = 0 
    items.each do |id , item|
      sum += item.price * item.quantity
    end
    sum
  end 

  def items
    session[:items] || {}
  end

  def datetimepicker_field_value(date)
    unless date.blank?
      l(date, :format => Spree.t('date_time_picker.format', :default => '%d-%m-%Y %H:%M'))
    else
      nil
    end
  end
end
