module ActiveAdmin
  module LTE
    module Views
      # Renders an ActiveAdmin::Menu as a set of unordered list items.
      #
      # This component takes cares of deciding which items should be
      # displayed given the current context and renders them appropriately.
      #
      # The entire component is rendered within one ul element.
      class TabbedNavigation < Component
        attr_reader :menu

        # Build a new tabbed navigation component.
        #
        # @param [ActiveAdmin::Menu] menu the Menu to render
        # @param [Hash] options the options as passed to the underlying ul element.
        #
        def build(menu, options = {})
          @menu = menu
          super(default_options.merge(options))
          build_menu
        end

        # The top-level menu items that should be displayed.
        def menu_items
          menu.items(self)
        end

        def tag_name
          'ul'
        end

        private

        def build_menu
          menu_items.each do |item|
            build_menu_item(item)
          end
        end

        def build_menu_item(item, is_child = false)
          li id: item.id do |li|
            li.add_class 'active' if item.current? assigns[:current_tab]
            
            icon =
              if is_child
                '<i class="fa fa-circle-o"></i>'
              else
                case item.id
                  when "admin"
                    '<i class="fa fa-cog"></i>'
                  when "dashboard"
                    '<i class="fa fa-dashboard"></i>'
                  when "barcode_search"
                    '<i class="fa fa-barcode" aria-hidden="true"></i>'
                  when "internal_product"
                    '<i class="fa fa-diamond"></i>'
                  when "stores"
                    '<i class="fa fa-building"></i>'
                  when "service"
                    '<i class="fa fa-thumbs-up"></i>'
                  when "fulfillment"
                    '<i class="fa fa-cart-plus"></i>'
                  when "pricing"
                    '<i class="fa fa-inr" aria-hidden="true"></i>'
                  when "reports"
                    '<i class="fa fa-line-chart" aria-hidden="true"></i>'
                  when "try_at_home"
                    '<i class="fa fa-home"></i>'
                  when "internal_transfer"
                    '<i class="fa fa-exchange" aria-hidden="true"></i>'
                  when "indus"
                    '<i class="fa fa-industry" aria-hidden="true"></i>'
                  when "glue"
                    '<i class="fa fa-arrows-alt" aria-hidden="true"></i>'
                  when "accounts"
                    '<i class="fa fa-calculator" aria-hidden="true"></i>'
                  else
                    '<i class="fa fa-bars"></i>'
                end
              end

            carret =
              if item.items(self).presence
                "<i class='fa fa-angle-left pull-right'></i>"
              end

            label_with_icon = <<-END.strip_heredoc.html_safe
              #{icon}
              <span>#{item.label(self)}</span>
              #{carret}
            END
            text_node link_to label_with_icon, item.url(self), item.html_options

            if children = item.items(self).presence
              li.add_class 'treeview'
              ul class: 'treeview-menu' do
                children.each { |child| build_menu_item child, true }
              end
            end
          end
        end

        def default_options
          dop ={ id: 'tabs', class: 'sidebar-menu'}
          dop["data-widget"] = "tree" 
          dop
        end
      end
    end
  end
end
