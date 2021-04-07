#  ___                                                     _
# / __\ ___   _ __ ___   _ __    ___   _ __    ___  _ __  | |_  ___
# / /   / _ \ | '_ ` _ \ | '_ \  / _ \ | '_ \  / _ \| '_ \ | __|/ __|
# / /___| (_) || | | | | || |_) || (_) || | | ||  __/| | | || |_ \__ \
# \____/ \___/ |_| |_| |_|| .__/  \___/ |_| |_| \___||_| |_| \__||___/
#                      |_|

module ActiveAdmin::ComponentsHelper
  def info_box(color:, icon: 'fa-star-o', data:)
    render 'active_admin/components/info_box', color: color, icon: icon, data: data
  end

  def info_box_progress(color:, icon: 'fa-star-o', data:)
    render 'active_admin/components/info_box_2', color: color, icon: icon, data: data
  end

  def modal_for(heading: {}, &block)
    body = capture(&block)
    block_to_partial('active_admin/components/modal', { heading: heading, body: body })
  end

  def block_to_partial(partial_name, options={})
    render(partial: partial_name, locals: options)
  end

  def modal_trigger(tag:, options: {})
    type = options.delete(:type)
    text = options.delete(:text)
    target    = options.delete(:target)
    css_class = options.delete(:css_class)

    return link_to text.html_safe, "#", class: css_class, data: { toggle: "modal", target: "##{target}" } if tag.to_sym == :link
    content_tag(:button, text.html_safe, class: css_class, data: { toggle: "modal", target: "##{target}" }, type: "button")
  end

  def lte_button(tag:, options: {})
    options.symbolize_keys!
    url  = options.delete(:url)
    type = options.delete(:type)
    text = options.delete(:text)
    css_class = options.delete(:css_class)

    return link_to(text.html_safe, url, class: css_class) if tag.to_sym == :link
    content_tag(:button, text.html_safe, class: css_class, type: type)
  end

  def carousel(id:, images:)
    render 'active_admin/components/carousel', id: id, images: images
  end
end
