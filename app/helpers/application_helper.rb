module ApplicationHelper

  def title
    base_title = "Shop Up"
    @title.nil? ? base_title : "#{base_title} | #@title"
  end

  def submit_value
    @submit_value ? @submit_value : "OK"
  end

  def is_c_and_a?(c, a)
    params[:controller] == c and params[:action] == a
  end

  def is_controller?(c)
    params[:controller] == c
  end

  def is_action?(a)
      params[:action] == a
  end

  def languages_select_tag(name = 'set_locale')
    languages = [%w(English en), %w(Russian ru), %w(Ukrainian ua)]
    options = options_for_select(languages, I18n.locale.to_s)
    form_tag locale_path, :id => "change_locale_form" do
      select_tag(name, options, :onchange => 'this.form.submit()')
    end
  end

  #todo make as Fixnum extension, which return string
  def to_storage(bytes)
    case bytes
      when 0
        "empty"
      when 1..1.kilobyte-1
        bytes.to_s + " b"
      when 1.kilobyte..1.megabyte-1
        (bytes.to_f/1.kilobyte).round(2).to_s + " Kb"
      when 1.megabyte..1.gigabyte-1
        (bytes.to_f/1.megabyte).round(2).to_s + " Mb"
      when 1.gigabyte..1.terabyte-1
        (bytes.to_f/1.gigabyte).round(2).to_s + " Gb"
      else
        "File is very long"
    end
  end

  def cut_long_string(content, length)
    clipped_string = sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
    content.length < length ? clipped_string : clipped_string[0..length-1] + "..."
  end

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "\n"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
  end

end
