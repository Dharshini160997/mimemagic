module ActiveAdmin
  module LTE
    module Views
      class Tabs < ActiveAdmin::Component
        builder_method :tabs

        def tab(title, options = {}, &block)
          title = title.to_s.titleize if title.is_a? Symbol
          @menu << build_menu_item(title, options, &block)
          @tabs_content << build_content_item(title, options, &block)
        end

        def build
          @menu = ul(class: 'nav nav-tabs', role: 'tablist')
          @tabs_content = div(class: 'tab-content')
        end

        def build_menu_item(title, options)
          options = options.reverse_merge('data-toggle' => 'tab')
          li { link_to title, "##{title.parameterize}", options }
        end

        def build_content_item(title, options, &block)
          options = options.reverse_merge(id: title.parameterize, class: 'tab-pane')
          div(options, &block)
        end
      end
    end
  end
end
