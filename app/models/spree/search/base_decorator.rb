Spree::Core::Search::Base.class_eval do

protected
  def prepare(params)
    @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])
    @properties[:keywords] = params[:keywords]
    @properties[:search] = params[:search]

    if params[:current_store_id]
      current_store = Spree::Store.find(params[:current_store_id])

      if current_store
        default_per_page = current_store.products_per_page.blank? ? Spree::Config[:products_per_page] : current_store.products_per_page
      else
        default_per_page = Spree::Config[:products_per_page]
      end
    end

    per_page = params[:per_page].to_i
    @properties[:per_page] = per_page > 0 ? per_page : default_per_page
    @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
  end
end