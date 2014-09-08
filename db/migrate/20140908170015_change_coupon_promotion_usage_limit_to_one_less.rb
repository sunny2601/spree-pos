class ChangeCouponPromotionUsageLimitToOneLess < ActiveRecord::Migration
  def up
    Spree::Promotion.where(event_name: 'spree.checkout.coupon_code_added').each do |p|
      if p.usage_limit == 2
        p.usage_limit = p.usage_limit - 1
        p.save!
      end
    end
  end

  def down
    Spree::Promotion.where(event_name: 'spree.checkout.coupon_code_added').each do |p|
      if p.usage_limit == 1
        p.usage_limit = p.usage_limit + 1
        p.save!
      end
    end
  end
end
