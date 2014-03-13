FactoryGirl.define do
  factory :store, :class => Spree::Store do
    name 'My store'
    code 'my_store'
    products_per_page 20
    domains 'www.example.com' # makes life simple, this is the default
    # integration session domain
  end

  factory :store_taxonomy, :class => Spree::StoreTaxonomy do
    store
    taxonomy
  end
end
