require 'spec_helper'

describe Spree::Taxonomy do
  ##############
  # attributes #
  ##############
  it "respond to a :store_ids" do
    should respond_to :store_ids
  end

  # Deprecated association attribute
  it "not respond to a :store_id" do
    should_not respond_to :store_id
  end

  ################
  # associations #
  ################
  # Describe here you model associations.
  it "have_many :store_taxonomies" do
    should have_many(:store_taxonomies).dependent(:nullify)
  end

  it "have_many :stores" do
    should have_many(:stores).through(:store_taxonomies)
  end

  # Deprecated association
  it "not respond to a :store" do
    should_not respond_to :store
  end
end
