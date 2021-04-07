module ActiveAdmin
  module LTE
    module Views
      class IndexAsTable < ActiveAdmin::Component
        def build(page_presenter, collection)
          table_options = {
            id: "index_table_#{active_admin_config.resource_name.plural}",
            sortable: true,
            class: 'index_table index table',
            i18n: active_admin_config.resource_class,
            paginator: page_presenter[:paginator] != false,
            row_class: page_presenter[:row_class]
          }

          table_for collection, table_options do |t|
            table_config_block = page_presenter.block || default_table
            instance_exec(t, &table_config_block)
          end
        end

        def table_for(*args, &block)
          insert_tag IndexTableFor, *args, &block
        end

        def default_table
          proc do
            selectable_column
            id_column if resource_class.primary_key # View based Models have no primary_key
            resource_class.content_columns.each do |col|
              column col.name.to_sym
            end
            actions
          end
        end

        def self.index_name
          'table'
        end

        #
        # Extend the default ActiveAdmin::Views::TableFor with some
        # methods for quickly displaying items on the index page
        #
        class IndexTableFor < ::ActiveAdmin::LTE::Views::TableFor
          # Display a column for checkbox
          def selectable_column
            return unless active_admin_config.batch_actions.any?
            column resource_selection_toggle_cell, class: 'selectable', sortable: false do |resource|
              resource_selection_cell resource
            end
          end

          def index_column(start_value = 1)
            column '#', class: 'col-index', sortable: false do |resource|
              @collection.offset_value + @collection.index(resource) + start_value
            end
          end

          # Display a column for the id
          def id_column
            raise "#{resource_class.name} as no primary_key!" unless resource_class.primary_key
            column(resource_class.human_attribute_name(resource_class.primary_key), sortable: resource_class.primary_key) do |resource|
              if controller.action_methods.include?('show')
                link_to resource.id, resource_path(resource), class: 'resource_id_link'
              else
                resource.id
              end
            end
          end

          def default_actions
            raise '`default_actions` is no longer provided in ActiveAdmin 1.x. Use `actions` instead.'
          end

          # Add links to perform actions.
          #
          # ```ruby
          # # Add default links.
          # actions
          #
          # # Add default links with a custom column title (empty by default).
          # actions name: 'A title!'
          #
          # # Append some actions onto the end of the default actions.
          # actions do |admin_user|
          #   link_to 'Grant Admin', grant_admin_admin_user_path(admin_user)
          # end
          #
          # # Custom actions without the defaults.
          # actions defaults: false do |admin_user|
          #   link_to 'Grant Admin', grant_admin_admin_user_path(admin_user)
          # end
          #
          # # Append some actions onto the end of the default actions displayed in a Dropdown Menu
          # actions dropdown: true do |admin_user|
          #   item 'Grant Admin', grant_admin_admin_user_path(admin_user)
          # end
          #
          # # Custom actions without the defaults displayed in a Dropdown Menu.
          # actions defaults: false, dropdown: true, dropdown_name: 'Additional actions' do |admin_user|
          #   item 'Grant Admin', grant_admin_admin_user_path(admin_user)
          # end
          #
          # ```

          def actions(options = {}, &block)
            name          = options.delete(:name)     { '' }
            defaults      = options.delete(:defaults) { true }
            dropdown      = options.delete(:dropdown) { false }
            dropdown_name = options.delete(:dropdown_name) { I18n.t 'active_admin.dropdown_actions.button_label', default: 'Actions' }
            options[:class] ||= 'col-actions'

            column name, options do |resource|
              if dropdown
                dropdown_menu dropdown_name, class: 'dropdown' do
                  items_default_actions(resource) if defaults
                  instance_exec(resource, &block) if block_given?
                end
              else
                text_node defaults(resource) if defaults
                text_node instance_exec(resource, &block) if block_given?
              end
            end
          end

          private

          def items_default_actions(resource)
            if controller.action_methods.include?('show') && authorized?(ActiveAdmin::Auth::READ, resource)
              item I18n.t('active_admin.view'), resource_path(resource), class: 'view_link'
            end
            if controller.action_methods.include?('edit') && authorized?(ActiveAdmin::Auth::UPDATE, resource)
              item I18n.t('active_admin.edit'), edit_resource_path(resource), class: 'edit_link'
            end
            if controller.action_methods.include?('destroy') && authorized?(ActiveAdmin::Auth::DESTROY, resource)
              item I18n.t('active_admin.delete'), resource_path(resource), class: 'delete_link',
                                                                           method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') }
            end
          end

          def defaults(resource, options = {})
            links = '<div class="text-center table-action"><div class="btn-group">'
            # I18n.t('active_admin.view')
            # I18n.t('active_admin.edit')
            # I18n.t('active_admin.delete')

            if controller.action_methods.include?('show') && authorized?(ActiveAdmin::Auth::READ, resource)
              links << link_to(ActiveAdmin::LTE.icon('fa-eye').html_safe, resource_path(resource), class: "member_link view_link btn btn-xs btn-info #{options[:css_class]}")
            end

            if controller.action_methods.include?('edit') && authorized?(ActiveAdmin::Auth::UPDATE, resource)
              links << link_to(ActiveAdmin::LTE.icon('fa-pencil').html_safe, edit_resource_path(resource), class: "member_link edit_link btn btn-xs bg-orange #{options[:css_class]}")
            end

            if controller.action_methods.include?('destroy') && authorized?(ActiveAdmin::Auth::DESTROY, resource)
              links << link_to(ActiveAdmin::LTE.icon('fa-trash').html_safe, resource_path(resource), class: "member_link delete_link btn btn-xs btn-danger #{options[:css_class]}",
              method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') })
            end

            links << '</div></div>'
            links.html_safe
          end

          class TableActions < ActiveAdmin::Component
            builder_method :table_actions

            def item(*args)
              text_node link_to *args
            end
          end
        end # IndexTableFor
      end # IndexAsTable
    end
  end
end
