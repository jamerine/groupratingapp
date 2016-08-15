class MrempEmployerExperienceController < ApplicationController
  def index
    @mremp_employee_experience_policy_level = MrempEmployeeExperiencePolicyLevel.all
    @mremp_employee_experience_policy_level_count = MrempEmployeeExperiencePolicyLevel.count
    @mremp_employee_experience_manual_class_level = MrempEmployeeExperienceManualClassLevel.all
    @mremp_employee_experience_manual_class_level_count = MrempEmployeeExperienceManualClassLevel.count
    @mremp_employee_experience_claim_level = MrempEmployeeExperienceClaimLevel.all
    @mremp_employee_experience_claim_level_count = MrempEmployeeExperienceClaimLevel.count
  end

  def parse
    MrempEmployeeExperiencePolicyLevel.parse_table
    # redirect_to root_url, notice: "Step 2 Completed: Mremp parsed into 3 different Mremp Records. Process Completed."
    redirect_to parse_index_path, notice: "The Mremp has been parsed"
  end
end
