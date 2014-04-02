require 'spec_helper'

describe Spree::StoreTaxonomy do
  ##############
  # attributes #
  ##############
  it "has a store_id" do
    should respond_to :store_id
  end

  it "has a taxonomy_id" do
    should respond_to :taxonomy_id
  end

  ################
  # associations #
  ################
  it "belongs to a :store" do
    should belong_to :store
  end

  it "belongs to a :taxonomy" do
    should belong_to :taxonomy
  end

  ###############
  # validations #
  ###############
  it "has a valid factory" do
    FactoryGirl.build(:store_taxonomy).should be_valid
  end

  describe "validations on :taxonomy_id" do
    context "on update" do
      it "requires a :taxonomy_id" do
        store_taxonomy = FactoryGirl.create(:store_taxonomy)

        store_taxonomy.taxonomy_id = nil
        store_taxonomy.should_not be_valid

        store_taxonomy.taxonomy_id = ''
        store_taxonomy.should_not be_valid
      end
    end

    context "on create" do
      it "debe requerir un :taxonomy_id" do
        pending "TODO - no se implemento ya que al agregar la validación 'on create' las FactoryGirl validas dejan de funcionar"
      end
    end
  end

  it "requires a :store_id" do
    FactoryGirl.build(:store_taxonomy, store_id: nil).should_not be_valid
    FactoryGirl.build(:store_taxonomy, store_id: '' ).should_not be_valid
  end
end
