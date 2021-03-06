module SpreeMultiDomain
  class Engine < Rails::Engine
    engine_name 'spree_multi_domain'

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      ['app', 'lib'].each do |dir|
        Dir.glob(File.join(File.dirname(__FILE__), "../../#{dir}/**/*_decorator*.rb")) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      Spree::Config.searcher_class = Spree::Search::MultiDomain
      ApplicationController.send :include, SpreeMultiDomain::MultiDomainHelpers
    end

    config.to_prepare &method(:activate).to_proc

    initializer "templates with dynamic layouts" do |app|
      ActionView::TemplateRenderer.class_eval do
        def find_layout_with_multi_store(layout, locals)
          store_layout = layout

          if @view.respond_to?(:current_store) && @view.current_store && !@view.controller.is_a?(Spree::Admin::BaseController)
            if layout.class == Proc
              store_layout = layout.call.gsub("layouts/", "layouts/#{@view.current_store.code}/")
            else
              store_layout = layout.gsub("layouts/", "layouts/#{@view.current_store.code}/")
            end
          end

          begin
            find_layout_without_multi_store(store_layout, locals)
          rescue ::ActionView::MissingTemplate
            find_layout_without_multi_store(layout, locals)
          end
        end

        alias_method_chain :find_layout, :multi_store
      end
    end


    # TODO - ErrorsController debe ser una configuracion de cada proyecto
    initializer "templates dynamically" do |app|
      ActionView::PartialRenderer.class_eval do
        def find_template_with_multi_store(path, locals)
          prefixes = path.include?(?/) ? [] : @lookup_context.prefixes

          store_prefixes = prefixes
          store_path     = path

          if @view.respond_to?(:current_store) && @view.current_store && !@view.controller.is_a?(Spree::Admin::BaseController)
            store_prefixes = (store_prefixes.map{|i| i.gsub('spree/', "spree/#{@view.current_store.code}/")} + store_prefixes).uniq unless store_prefixes.nil?
            store_path     = store_path.gsub('spree/', "spree/#{@view.current_store.code}/") unless store_path.nil?
          end

          begin
            @lookup_context.find_template(store_path, store_prefixes, true, locals, @details)
          rescue ::ActionView::MissingTemplate
            @lookup_context.find_template(path, prefixes, true, locals, @details)
          end
        end

        alias_method_chain :find_template, :multi_store
      end

      ActionView::TemplateRenderer.class_eval do
        def find_template_with_multi_store(name, prefixes = [], partial = false, keys = [], options = {})
          if prefixes.nil?
            store_prefixes = nil
          elsif @view.respond_to?(:current_store) && @view.current_store && !@view.controller.is_a?(Spree::Admin::BaseController)
            spree = /^spree\//

            store_prefixes = []

            prefixes.each do |i|
              store_prefixes << i.gsub(spree, "spree/#{@view.current_store.code}/") if i.match(spree)
            end

            store_prefixes = (store_prefixes + prefixes).uniq
          else
            store_prefixes = prefixes
          end

          begin
            @lookup_context.find_template(name, store_prefixes, partial, keys, options)
          rescue ::ActionView::MissingTemplate
            @lookup_context.find_template(name, prefixes, partial, keys, options)
          end
        end
        alias_method_chain :find_template, :multi_store
      end
    end

    initializer "current order decoration" do |app|
      require 'spree/core/controller_helpers/order'
      ::Spree::Core::ControllerHelpers::Order.module_eval do
        def current_order_with_multi_domain(create_order_if_necessary = false)
          current_order_without_multi_domain(create_order_if_necessary: create_order_if_necessary)

          if @current_order and current_store
            if @current_order.store.nil?
              @current_order.update_attribute(:store_id, current_store.id)
            elsif @current_order.store_id != current_store.id
              @current_order = nil
              current_order_without_multi_domain(create_order_if_necessary: true)
              @current_order.update_attribute(:store_id, current_store.id)
            end
          end

          @current_order
        end
        alias_method_chain :current_order, :multi_domain
      end
    end

    initializer 'spree.promo.register.promotions.rules' do |app|
      app.config.spree.promotions.rules << Spree::Promotion::Rules::Store
    end

    initializer :assets do |config|
      Rails.application.config.assets.paths << root.join("app", "assets", "images")
    end
  end
end
