module RatesHelper
  def calculate_cell_color(percent_change)
    percent_change.to_f >= 0.00 ? 'success' : 'danger'
  end

  def calculate_rate_change(old_number, new_number)
    increase = new_number - old_number
    return 'No Change' if old_number == 0 || increase == 0
    "#{number_with_precision((increase / old_number) * 100, precision: 2)}%"
  end
end