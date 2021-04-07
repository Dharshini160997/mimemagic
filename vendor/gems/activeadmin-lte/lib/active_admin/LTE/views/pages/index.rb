module ActiveAdmin
  module LTE
    module Views
      module Pages
        class Index < Base
          def title
            if Proc === config[:title]
              controller.instance_exec &config[:title]
            else
              config[:title] || assigns[:page_title] || active_admin_config.plural_resource_label
            end
          end

          # Retreives the given page presenter, or uses the default.
          def config
            active_admin_config.get_page_presenter(:index, params[:as]) ||
              ActiveAdmin::PagePresenter.new(as: :table)
          end

          # Render's the index configuration that was set in the
          # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table

          def main_content
            div class: 'box box-default' do
              div class: 'box-header' do
                filter_form_toggle if active_admin_config.filters.any?
              end
              text_node form_tag active_admin_config.batch_action_path(params), id: 'collection_selection'
              input name: :batch_action,        id: :batch_action,        type: :hidden
              input name: :batch_action_inputs, id: :batch_action_inputs, type: :hidden
              div class: 'box-header' do
                if batch_actions_to_display(active_admin_config.batch_actions).length > 0 || active_admin_config.scopes.any?
                  div class: 'box-header-inner' do
                    build_batch_actions_selector if batch_actions_to_display(active_admin_config.batch_actions).length > 0
                    build_scopes if active_admin_config.scopes.any?
                  end
                end
                
              end
              div class: 'paginated_collection' do
                div class: 'box-body table-responsive no-padding' do
                  build_collection
                end
              end
              raw = <<-END.strip_heredoc
                </form>
              END
              text_node raw.html_safe
              div class: 'box-footer' do
                render_index_footer
              end
            end
          end

          protected

          # def wrap_with_batch_action_form(&block)
          #   if active_admin_config.batch_actions.any?
          #     batch_action_form(&block)
          #   else
          #     block.call
          #   end
          # end
          #

          include ::ActiveAdmin::Helpers::Collection

          def filter_form_toggle
            div class: 'pull-right filter-toggle' do
              span class: 'btn btn-sm btn-default' do
                text_node 'Filter'
                i class: 'fa fa-filter'
              end
            end
            build_index_filter
          end

          def items_in_collection?
            !collection_is_empty?
          end

          def build_collection
            if items_in_collection?
              render_index
            else
              if params[:q] || params[:scope]
                render_empty_results
              else
                render_blank_slate
              end
            end
          end

          include ::ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper

          def build_index_filter
            active = (request.query_parameters[:q] ? 'active' : '')
            div class: "index-filter-outer #{active}" do
              div class: 'index-filter' do
                h3 class: 'no-margin' do
                  i class: 'fa fa-filter'
                  text_node 'Filter'
                end
                text_node active_admin_filters_form_for assigns[:search], active_admin_config.filters
              end
            end
          end

          def any_table_tools?
            active_admin_config.batch_actions.any? ||
              active_admin_config.scopes.any? ||
              active_admin_config.page_presenters[:index].try(:size).try(:>, 1)
          end

          def build_batch_actions_selector
            if active_admin_config.batch_actions.any?
              insert_tag view_factory.batch_action_dropdown, active_admin_config.batch_actions
            end
          end

          def build_scopes
            if active_admin_config.scopes.any?
              scope_options = {
                scope_count: config[:scope_count].nil? ? true : config[:scope_count]
              }

              scopes_renderer active_admin_config.scopes, scope_options
            end
          end

          def build_index_list
            indexes = active_admin_config.page_presenters[:index]

            if indexes.is_a?(Hash) && indexes.length > 1
              index_classes = []
              active_admin_config.page_presenters[:index].each do |_type, page_presenter|
                index_classes << find_index_renderer_class(page_presenter[:as])
              end

              index_list_renderer index_classes
            end
          end

          # Returns the actual class for renderering the main content on the index
          # page. To set this, use the :as option in the page_presenter block.
          def find_index_renderer_class(klass)
            klass.is_a?(Class) ? klass :
              ::ActiveAdmin::LTE::Views.const_get('IndexAs' + klass.to_s.camelcase)
          end

          def render_blank_slate
            blank_slate_content = I18n.t('active_admin.blank_slate.content', resource_name: active_admin_config.plural_resource_label)
            if controller.action_methods.include?('new') && authorized?(ActiveAdmin::Auth::CREATE, active_admin_config.resource_class)
              blank_slate_content = [blank_slate_content, blank_slate_link].compact.join(' ')
            end
            insert_tag(view_factory.blank_slate, blank_slate_content)
          end

          def render_empty_results
            empty_results_content = I18n.t('active_admin.pagination.empty', model: active_admin_config.plural_resource_label)
            insert_tag(view_factory.blank_slate, empty_results_content)
          end

          def render_index_footer
            renderer_class   = find_index_renderer_class(config[:as])
            paginator        = config[:paginator].nil?      ? true : config[:paginator]
            download_links   = config[:download_links].nil? ? active_admin_config.namespace.download_links : config[:download_links]
            pagination_total = config[:pagination_total].nil? ? true : config[:pagination_total]
            page_entries     = config[:page_entries].nil? ? true : config[:page_entries]

            paginated_collection(
              collection, entry_name: active_admin_config.resource_label,
                          entries_name: active_admin_config.plural_resource_label(count: collection_size),
                          download_links: download_links,
                          page_entries: page_entries,
                          paginator: paginator,
                          pagination_total: pagination_total
            )
          end

          def render_index
            renderer_class = find_index_renderer_class(config[:as])
            div class: 'index_content' do
              insert_tag(renderer_class, config, collection)
            end
          end

          private

          def blank_slate_link
            if config.options.key?(:blank_slate_link)
              blank_slate_link = config.options[:blank_slate_link]
              instance_exec(&blank_slate_link) if blank_slate_link.is_a?(Proc)
            else
              default_blank_slate_link
            end
          end

          def default_blank_slate_link
            link_to(I18n.t('active_admin.blank_slate.link'), new_resource_path)
          end

          def batch_actions_to_display(batch_actions)
            batch_actions.select do |batch_action|
              call_method_or_proc_on(self, batch_action.display_if_block)
            end
          end
        end
      end
    end
  end
end
