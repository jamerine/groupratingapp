module RatesHelper
  def calculate_cell_color(percent_change)
    percent_change.to_f > 0.00 ? 'success' : 'danger'
  end
end