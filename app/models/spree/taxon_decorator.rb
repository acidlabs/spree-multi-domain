module Spree
  Taxon.class_eval do
    scope :by_store, lambda {|store| joins(taxonomy: :stores).where("spree_stores.id = ?", store)}
  end
end
