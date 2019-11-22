module ApplicationHelper
  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end

  def flash_classes
    {
      notice:  'success',
      success: 'success',
      danger:  'danger',
      error:   'danger',
      alert:   'warning',
      warning: 'warning'
    }
  end

  def flash_class(key, prefix)
    key = key.to_sym

    style = flash_classes.keys.include?(key) ? flash_classes[key] : 'info'
    "#{prefix}-#{style}"
  end

  def flash_alert_class(key)
    flash_class(key, 'alert')
  end

  def flash_nav_alert_class(key)
    flash_class(key, 'btn')
  end
end
