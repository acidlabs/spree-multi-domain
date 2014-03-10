class CreateSpreeStoreTaxonomies < ActiveRecord::Migration
  def change
    create_table :spree_store_taxonomies do |t|
      t.references :store,    index: true
      t.references :taxonomy, index: true

      t.timestamps
    end
  end
end
