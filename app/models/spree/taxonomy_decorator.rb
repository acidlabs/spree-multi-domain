Spree::Taxonomy.class_eval do
  belongs_to :store

  scope :by_store, lambda {|store| where("spree_taxonomies.store_id = ?", store)}
end
