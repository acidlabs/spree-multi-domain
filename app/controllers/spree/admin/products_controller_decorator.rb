Spree::Admin::ProductsController.class_eval do
  update.before :set_stores

  private
  def set_stores
    # Si estoy actualizando las propiedades del producto no hago nada
    return if params[:product].key?(:product_properties_attributes)

    @product.store_ids = nil unless params[:product].key?(:store_ids)
  end

end
