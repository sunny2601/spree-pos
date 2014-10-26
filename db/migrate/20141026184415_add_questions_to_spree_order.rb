class AddQuestionsToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :pos_returning_user, :boolean, default: false
    add_column :spree_orders, :pos_know_website, :boolean, default: false
  end
end
