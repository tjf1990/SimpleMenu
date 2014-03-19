module ApplicationHelper

  #read, update, delete btn toolbar with support for additional buttons
  #other_buttons = [{path: path_helper, icon_class:(string), is_enabled:(bool = true)}]
  def rud_toolbar(model, enabled_buttons = {}, other_buttons = {})
    render partial: 'shared/rud_toolbar', locals: {model: model, enabled_buttons: enabled_buttons, other_buttons: other_buttons}
  end

  def new_model_toolbar(model)
    render partial: 'shared/new_model_toolbar', locals: {model: model}
  end

  #render form title with optional block
  def page_title(title = nil, &block)
    render partial: 'shared/title', locals: {title:title, block: (block_given? ? capture(&block) : '')}
  end

  #generate a bootstrap form help block(under the input tags)
  def error_help_block(text)
    render partial: 'shared/help_block', locals: {is_error: true, text: text.humanize}
  end

  def success_alert_box(text)
    render partial: 'shared/alert_box', locals: {text: text}
  end

  #page button scroller, mapped to index.js constants
  def index_page_control(pages)
    render partial: 'shared/index_page_control', locals: {pages: pages}
  end
end
