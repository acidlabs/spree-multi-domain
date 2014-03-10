module Spree
  Taxonomy.class_eval do
    has_many :store_taxonomies, dependent: :nullify
    has_many :stores,             through: :store_taxonomies

    scope :by_store, lambda {|store| joins(:stores).where("spree_stores.id = ?", store)}
  end
end
