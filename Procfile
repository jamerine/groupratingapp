web: bundle exec puma -C config/puma.rb

worker1: bundle exec sidekiq -C -q default -q import_file -q import_process -q parse_file -q group_rating_step_one -q group_rating_step_two -q group_rating_step_three -q group_rating_step_four -q group_rating_step_five -q group_rating_step_six -q group_rating_step_seven -q group_rating_step_eight -q policy_update_create -q policy_update_create_process -q manual_class_update_create -q manual_class_update_create_process -q payroll_update_create -q payroll_update_create_process -q claim_update_create -q claim_update_create_process

worker2: bundle exec sidekiq -C -q default -q import_file -q import_process -q parse_file -q policy_update_create -q policy_update_create_process -q manual_class_update_create -q manual_class_update_create_process -q payroll_update_create -q payroll_update_create_process -q claim_update_create -q claim_update_create_process
