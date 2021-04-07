#         _                _
#  _ __  | | _   _   __ _ (_) _ __
# | '_ \ | || | | | / _` || || '_ \
# | |_) || || |_| || (_| || || | | |
# | .__/ |_| \__,_| \__, ||_||_| |_|
# |_|               |___/

module ActiveAdmin::PluginsHelper
  def chart_js_line_chart(labels:, datasets:,  options: )
    raise 'labels must be a array' unless labels.is_a? Array
    raise 'datasets must be a array' unless datasets.is_a? Array
    raise 'options must be a hash' unless options.is_a? Hash

    options.deep_symbolize_keys!
    options[:width]  ||= 400
    options[:height] ||= 300

    colorize_dataset(datasets)

    render 'active_admin/components/chartjs', labels: labels, datasets: datasets, options: options
  end

  def colorize_dataset(datasets)
    datasets.each do |dataset|
      r, g, b = (0..2).map { rand(250).to_s }
      dataset.fill  = "rgba(#{r}, #{g}, #{b}, 0.2)"
      dataset.color = "rgba(#{r}, #{g}, #{b}, 1)"
    end
  end

  def timeline_label(text:, css_class:)
    Arbre::Context.new do
      li class: "time-label" do
        span text, class: css_class
      end
    end
  end

  def timeline_header(text:, href: '#', other_class: nil)
    Arbre::Context.new do
      h3 class: "timeline-header #{other_class}" do
        a text, href: href
      end
    end
  end

  def timeline_time(time:)
    Arbre::Context.new do
      span class: "time" do
        text_node time
        i class: "fa fa-clock-o"
      end
    end
  end

  def timeline_body
    Arbre::Context.new do
      div class: "timeline-body" do
        yield
      end
    end
  end
end
