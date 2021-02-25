class AddTypeToBwcCodesConstantValue < ActiveRecord::Migration
  def change
    add_column :bwc_codes_constant_values, :employer_type, :integer, default: 0
  end
end
