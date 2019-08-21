# == Schema Information
#
# Table name: sc220_rec3_employer_ar_transactions
#
#  id                              :integer          not null, primary key
#  representative_number           :integer
#  representative_type             :integer
#  descriptionar                   :string
#  record_type                     :integer
#  request_type                    :integer
#  policy_type                     :string
#  policy_number                   :integer
#  business_sequence_number        :integer
#  trans_date                      :date
#  invoice_number                  :string
#  billing_trans_status_code       :string
#  trans_amount                    :float
#  trans_type                      :string
#  paid_amount                     :float
#  n2nd_trans_date                 :date
#  n2nd_invoice_number             :string
#  n2nd_billing_trans_status_code  :string
#  n2nd_trans_amount               :float
#  n2nd_trans_type                 :string
#  n2nd_paid_amount                :float
#  n3rd_trans_date                 :date
#  n3rd_invoice_number             :string
#  n3rd_billing_trans_status_code  :string
#  n3rd_trans_amount               :float
#  n3rd_trans_type                 :string
#  n3rd_paid_amount                :float
#  n4th_trans_date                 :date
#  n4th_invoice_number             :string
#  n4th_billing_trans_status_code  :string
#  n4th_trans_amount               :float
#  n4th_trans_type                 :string
#  n4th_paid_amount                :float
#  n5th_trans_date                 :date
#  n5th_invoice_number             :string
#  n5th_billing_trans_status_code  :string
#  n5th_trans_amount               :float
#  n5th_trans_type                 :string
#  n5th_paid_amount                :float
#  n6th_trans_date                 :date
#  n6th_invoice_number             :string
#  n6th_billing_trans_status_code  :string
#  n6th_trans_amount               :float
#  n6th_trans_type                 :string
#  n6th_paid_amount                :float
#  n7th_trans_date                 :date
#  n7th_invoice_number             :string
#  n7th_billing_trans_status_code  :string
#  n7th_trans_amount               :float
#  n7th_trans_type                 :string
#  n7th_paid_amount                :float
#  n8th_trans_date                 :date
#  n8th_invoice_number             :string
#  n8th_billing_trans_status_code  :string
#  n8th_trans_amount               :float
#  n8th_trans_type                 :string
#  n8th_paid_amount                :float
#  n9th_trans_date                 :date
#  n9th_invoice_number             :string
#  n9th_billing_trans_status_code  :string
#  n9th_trans_amount               :float
#  n9th_trans_type                 :string
#  n9th_paid_amount                :float
#  n10th_trans_date                :date
#  n10th_invoice_number            :string
#  n10th_billing_trans_status_code :string
#  n10th_trans_amount              :float
#  n10th_trans_type                :string
#  n10th_paid_amount               :float
#  n11th_trans_date                :date
#  n11th_invoice_number            :string
#  n11th_billing_trans_status_code :string
#  n11th_trans_amount              :float
#  n11th_trans_type                :string
#  n11th_paid_amount               :float
#  n12th_trans_date                :date
#  n12th_invoice_number            :string
#  n12th_billing_trans_status_code :string
#  n12th_trans_amount              :float
#  n12th_trans_type                :string
#  n12th_paid_amount               :float
#  n13th_trans_date                :date
#  n13th_invoice_number            :string
#  n13th_billing_trans_status_code :string
#  n13th_trans_amount              :float
#  n13th_trans_type                :string
#  n13th_paid_amount               :float
#  n14th_trans_date                :date
#  n14th_invoice_number            :string
#  n14th_billing_trans_status_code :string
#  n14th_trans_amount              :float
#  n14th_trans_type                :string
#  n14th_paid_amount               :float
#  n15th_trans_date                :date
#  n15th_invoice_number            :string
#  n15th_billing_trans_status_code :string
#  n15th_trans_amount              :float
#  n15th_trans_type                :string
#  n15th_paid_amount               :float
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class Sc220Rec3EmployerArTransaction < ActiveRecord::Base
end
