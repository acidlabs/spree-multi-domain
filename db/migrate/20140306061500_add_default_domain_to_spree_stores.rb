class AddDefaultDomainToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :default_domain, :string
  end
end
