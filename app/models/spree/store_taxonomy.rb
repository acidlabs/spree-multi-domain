module Spree
  class StoreTaxonomy < ActiveRecord::Base
    belongs_to :store
    belongs_to :taxonomy

    validates :store_id,    presence: true
    validates :taxonomy_id, presence: true, on: :update
  end
end
