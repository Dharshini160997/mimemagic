module ActiveAdmin
  module LTE
    module Views

      class Panel < ActiveAdmin::Component
        builder_method :panel

        def build(title, attributes = {})
          icon_name = attributes.delete(:icon)
          collapse  = attributes.delete(:collapse)
          border    = attributes.delete(:border) ? 'with-border' : nil
          type      = attributes[:type] ? "box-#{attributes.delete(:type)}" : nil
          icn       = icon_name ? ActiveAdmin::LTE.icon(icon_name, 'margin-right') : ""
          super(attributes)
          add_class "box #{type}"
          remove_class "panel"
          @title = div class: "box-header #{border}" do
            h3(icn.html_safe + title.to_s.capitalize, class: 'box-title')
            # if collapse
              div class: "box-tools pull-right" do
                button type: "button", class: "btn btn-box-tool", :'data-widget' => "collapse" do
                  i class: "fa fa-minus"
                end
              end
            # end
          end
          @contents = div(class: "box-body")
        end

        def add_child(child)
          if @contents
            @contents << child
          else
            super
          end
        end

        # Override children? to only report children when the panel's
        # contents have been added to. This ensures that the panel
        # correcly appends string values, etc.
        def children?
          @contents.children?
        end

      end

    end
  end
end
