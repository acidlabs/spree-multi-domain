Spree::UsersController.class_eval do
  def show
    @orders = @user.orders.complete.where(store: current_store).order('completed_at desc')
  end
end