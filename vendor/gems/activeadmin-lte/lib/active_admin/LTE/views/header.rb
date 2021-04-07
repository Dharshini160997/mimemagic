module ActiveAdmin
  module LTE
    module Views
      class Header < Component

        def tag_name
          'header'
        end

        def build(namespace, menu)
          super(id: "header", class: 'main-header')

          @namespace = namespace
          @menu = menu
          @utility_menu = @namespace.fetch_menu(:utility_navigation)

          build_site_title
          # build_global_navigation
          build_navbar
        end


        # def build_site_title
        #   insert_tag view_factory.site_title, @namespace
        # end

        # def build_mini_site_title
        #   insert_tag view_factory.mini_site_title, @namespace
        # end

        def build_site_title
          raw = <<-END.strip_heredoc
            <a class="logo">
              <span class="logo-mini">
               #{ ActionController::Base.helpers.image_tag("logo.png", height: "36") }
              </span>
              <span class="logo-lg">
                #{ ActionController::Base.helpers.image_tag("logo.png", height: "46", style: "margin-bottom:5px;") } #{@namespace.site_title}
              </span>
            </a>
          END
          text_node raw.html_safe
        end

        def build_navbar
          nav class: 'navbar navbar-static-top',style:'display:flex;-js-display: flex;' , role: 'navigation' do
            build_navbar_sidebar_toggle
            div class: 'navbar-custom-menu',style:'display:flex;-js-display: flex;'  do
              build_searchbar
              build_utility_navigation
            end
          end
        end

        def build_navbar_sidebar_toggle
          raw = <<-END.strip_heredoc
            <a href="#" class="navbar-btn sidebar-toggle" data-toggle="push-menu" role="button">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
          END
          text_node raw.html_safe
        end

        def build_searchbar
          raw = <<-END.strip_heredoc
          <div id="bs-example-navbar-collapse-1">      
            <div style="padding-left:5px;padding-right:5px;">
            <form id="search_form" action="">
              <div class="input-group" style="margin-top:8px;">
                <div class="input-group-btn">
                  <button type="button" id="search_order_id" class="btn btn-default active" ><span class="fa fa-hashtag"></span></button>
                  <button type="button" id="search_mail_id" class="btn btn-default" ><span class="fa fa-envelope"></span></button>
                  <button type="button" id="search_mobile" class="btn btn-default" ><span class="fa fa-mobile fa-lg"></span></button> 
                </div>
                <input id="search-bar" name="order[]" type="text" class="form-control" placeholder="Search...">                                    
                <span class="input-group-btn">
                  <input type="submit" value="submit" style="visibility: hidden;">
                </span>
              </div>
              </form>
            </div>
          </div><!-- /.navbar-collapse -->
          END
          text_node raw.html_safe
        end

        # def build_global_navigation
        #   insert_tag view_factory.global_navigation, @menu, class: 'header-item tabs'
        # end

        def build_utility_navigation
          insert_tag view_factory.utility_navigation, @utility_menu, id: "utility_nav"
        end
      end
    end
  end
end
