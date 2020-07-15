module MirasHelper
  def display_date(field)
    return '' unless field.present?
    l field, format: :mira
  end
end