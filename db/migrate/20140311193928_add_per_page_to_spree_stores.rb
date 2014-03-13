class AddPerPageToSpreeStores < ActiveRecord::Migration
  def self.up    
    change_table :spree_stores do |t|
      t.integer :products_per_page
    end
  end

  def self.down
    change_table :spree_stores do |t|
      t.remove :products_per_page
    end
  end
end
