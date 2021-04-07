module ActiveAdmin
  module LTE
    module Views
      class UtilityNavigation < Component
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

        def build_menu_item(item)
          li id: item.id do |li|
            li.add_class "current" if item.current? assigns[:current_tab]
            if item.id == "logout"
              raw = <<-END.strip_heredoc
                <a title="Signout" href="#{item.url(self)}">
                    <i class="fa fa-sign-out"></i>
                </a>
              END
              text_node raw.html_safe 
            else
              raw = <<-END.strip_heredoc
                <a class="right-nav" title="#{item.label(self)}" href="#{item.url(self)}">
                    #{item.label(self)}
                </a>
              END
              text_node raw.html_safe
            end

            if children = item.items(self).presence
              li.add_class "has_nested"
              ul do
                children.each{ |child| build_menu_item child }
              end
            end
          end
        end

        def default_options
          { id: "tabs", class: "nav navbar-nav",style:"display:flex;-js-display: flex;"  }
        end
      end
    end
  end
end
