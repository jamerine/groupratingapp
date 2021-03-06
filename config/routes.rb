# == Route Map
#
#                                                Prefix Verb       URI Pattern                                                                        Controller#Action
#                                new_admin_user_session GET        /admin/login(.:format)                                                             active_admin/devise/sessions#new
#                                    admin_user_session POST       /admin/login(.:format)                                                             active_admin/devise/sessions#create
#                            destroy_admin_user_session DELETE|GET /admin/logout(.:format)                                                            active_admin/devise/sessions#destroy
#                                   admin_user_password POST       /admin/password(.:format)                                                          active_admin/devise/passwords#create
#                               new_admin_user_password GET        /admin/password/new(.:format)                                                      active_admin/devise/passwords#new
#                              edit_admin_user_password GET        /admin/password/edit(.:format)                                                     active_admin/devise/passwords#edit
#                                                       PATCH      /admin/password(.:format)                                                          active_admin/devise/passwords#update
#                                                       PUT        /admin/password(.:format)                                                          active_admin/devise/passwords#update
#                                            admin_root GET        /admin(.:format)                                                                   admin/dashboard#index
#          batch_action_admin_manual_class_calculations POST       /admin/manual_class_calculations/batch_action(.:format)                            admin/manual_class_calculations#batch_action
#                       admin_manual_class_calculations GET        /admin/manual_class_calculations(.:format)                                         admin/manual_class_calculations#index
#                        admin_manual_class_calculation GET        /admin/manual_class_calculations/:id(.:format)                                     admin/manual_class_calculations#show
#                batch_action_admin_policy_calculations POST       /admin/policy_calculations/batch_action(.:format)                                  admin/policy_calculations#batch_action
#                             admin_policy_calculations GET        /admin/policy_calculations(.:format)                                               admin/policy_calculations#index
#                              admin_policy_calculation GET        /admin/policy_calculations/:id(.:format)                                           admin/policy_calculations#show
#                             batch_action_admin_quotes POST       /admin/quotes/batch_action(.:format)                                               admin/quotes#batch_action
#                                          admin_quotes GET        /admin/quotes(.:format)                                                            admin/quotes#index
#                                           admin_quote GET        /admin/quotes/:id(.:format)                                                        admin/quotes#show
#                                       admin_dashboard GET        /admin/dashboard(.:format)                                                         admin/dashboard#index
#                   batch_action_admin_account_programs POST       /admin/account_programs/batch_action(.:format)                                     admin/account_programs#batch_action
#                                admin_account_programs GET        /admin/account_programs(.:format)                                                  admin/account_programs#index
#                                 admin_account_program GET        /admin/account_programs/:id(.:format)                                              admin/account_programs#show
#                           batch_action_admin_accounts POST       /admin/accounts/batch_action(.:format)                                             admin/accounts#batch_action
#                                        admin_accounts GET        /admin/accounts(.:format)                                                          admin/accounts#index
#                                         admin_account GET        /admin/accounts/:id(.:format)                                                      admin/accounts#show
#                                        admin_comments GET        /admin/comments(.:format)                                                          admin/comments#index
#                                                       POST       /admin/comments(.:format)                                                          admin/comments#create
#                                         admin_comment GET        /admin/comments/:id(.:format)                                                      admin/comments#show
#                                                       DELETE     /admin/comments/:id(.:format)                                                      admin/comments#destroy
#                                           sidekiq_web            /sidekiq                                                                           Sidekiq::Web
#                             account_edit_group_rating GET        /accounts/:account_id/edit_group_rating(.:format)                                  accounts#edit_group_rating
#                              account_edit_group_retro GET        /accounts/:account_id/edit_group_retro(.:format)                                   accounts#edit_group_retro
#                             account_group_rating_calc POST       /accounts/:account_id/group_rating_calc(.:format)                                  accounts#group_rating_calc
#                              account_group_retro_calc POST       /accounts/:account_id/group_retro_calc(.:format)                                   accounts#group_retro_calc
#                                  account_group_rating POST       /accounts/:account_id/group_rating(.:format)                                       accounts#group_rating
#                                        account_assign POST       /accounts/:account_id/assign(.:format)                                             accounts#assign
#                                account_assign_address POST       /accounts/:account_id/assign_address(.:format)                                     accounts#assign_address
#                                   account_risk_report GET        /accounts/:account_id/risk_report(.:format)                                        accounts#risk_report
#                             account_claim_loss_export POST       /accounts/:account_id/claim_loss_export(.:format)                                  accounts#claim_loss_export
#                      account_ranged_claim_loss_export GET        /accounts/:account_id/ranged_claim_loss_export(.:format)                           accounts#ranged_claim_loss_export
#                 account_ranged_claim_loss_export_form POST       /accounts/:account_id/ranged_claim_loss_export_form(.:format)                      accounts#ranged_claim_loss_export_form
#                               account_new_risk_report GET        /accounts/:account_id/new_risk_report(.:format)                                    accounts#new_risk_report
#                                     account_retention GET        /accounts/:account_id/retention(.:format)                                          accounts#retention
#                                    account_roc_report GET        /accounts/:account_id/roc_report(.:format)                                         accounts#roc_report
#                      account_group_rating_calculation POST       /accounts/:account_id/group_rating_calculation(.:format)                           accounts#group_rating_calculation
#                        account_note_remove_attachment DELETE     /accounts/:account_id/notes/:note_id/remove_attachment(.:format)                   notes#remove_attachment
#                            update_pinned_account_note PATCH      /accounts/:account_id/notes/:id/update_pinned(.:format)                            notes#update_pinned
#                                         account_notes GET        /accounts/:account_id/notes(.:format)                                              notes#index
#                                                       POST       /accounts/:account_id/notes(.:format)                                              notes#create
#                                      new_account_note GET        /accounts/:account_id/notes/new(.:format)                                          notes#new
#                                     edit_account_note GET        /accounts/:account_id/notes/:id/edit(.:format)                                     notes#edit
#                                          account_note GET        /accounts/:account_id/notes/:id(.:format)                                          notes#show
#                                                       PATCH      /accounts/:account_id/notes/:id(.:format)                                          notes#update
#                                                       PUT        /accounts/:account_id/notes/:id(.:format)                                          notes#update
#                                                       DELETE     /accounts/:account_id/notes/:id(.:format)                                          notes#destroy
#                                    account_affiliates GET        /accounts/:account_id/affiliates(.:format)                                         affiliates#index
#                                                       POST       /accounts/:account_id/affiliates(.:format)                                         affiliates#create
#                                 new_account_affiliate GET        /accounts/:account_id/affiliates/new(.:format)                                     affiliates#new
#                                edit_account_affiliate GET        /accounts/:account_id/affiliates/:id/edit(.:format)                                affiliates#edit
#                                     account_affiliate GET        /accounts/:account_id/affiliates/:id(.:format)                                     affiliates#show
#                                                       PATCH      /accounts/:account_id/affiliates/:id(.:format)                                     affiliates#update
#                                                       PUT        /accounts/:account_id/affiliates/:id(.:format)                                     affiliates#update
#                                                       DELETE     /accounts/:account_id/affiliates/:id(.:format)                                     affiliates#destroy
#                       import_account_process_accounts POST       /accounts/import_account_process(.:format)                                         accounts#import_account_process
#           autocomplete_policy_number_entered_accounts GET        /accounts/autocomplete_policy_number_entered(.:format)                             accounts#autocomplete_policy_number_entered
#                                              accounts GET        /accounts(.:format)                                                                accounts#index
#                                                       POST       /accounts(.:format)                                                                accounts#create
#                                           new_account GET        /accounts/new(.:format)                                                            accounts#new
#                                          edit_account GET        /accounts/:id/edit(.:format)                                                       accounts#edit
#                                               account GET        /accounts/:id(.:format)                                                            accounts#show
#                                                       PATCH      /accounts/:id(.:format)                                                            accounts#update
#                                                       PUT        /accounts/:id(.:format)                                                            accounts#update
#                                                       DELETE     /accounts/:id(.:format)                                                            accounts#destroy
#       import_account_program_process_account_programs POST       /account_programs/import_account_program_process(.:format)                         account_programs#import_account_program_process
#                    update_individual_account_programs PUT        /account_programs/update_individual(.:format)                                      account_programs#update_individual
#                                      account_programs GET        /account_programs(.:format)                                                        account_programs#index
#                                                       POST       /account_programs(.:format)                                                        account_programs#create
#                                   new_account_program GET        /account_programs/new(.:format)                                                    account_programs#new
#                                  edit_account_program GET        /account_programs/:id/edit(.:format)                                               account_programs#edit
#                                       account_program GET        /account_programs/:id(.:format)                                                    account_programs#show
#                                                       PATCH      /account_programs/:id(.:format)                                                    account_programs#update
#                                                       PUT        /account_programs/:id(.:format)                                                    account_programs#update
#                                                       DELETE     /account_programs/:id(.:format)                                                    account_programs#destroy
#                   import_affiliate_process_affiliates POST       /affiliates/import_affiliate_process(.:format)                                     affiliates#import_affiliate_process
#                                            affiliates GET        /affiliates(.:format)                                                              affiliates#index
#                                                       POST       /affiliates(.:format)                                                              affiliates#create
#                                         new_affiliate GET        /affiliates/new(.:format)                                                          affiliates#new
#                                        edit_affiliate GET        /affiliates/:id/edit(.:format)                                                     affiliates#edit
#                                             affiliate GET        /affiliates/:id(.:format)                                                          affiliates#show
#                                                       PATCH      /affiliates/:id(.:format)                                                          affiliates#update
#                                                       PUT        /affiliates/:id(.:format)                                                          affiliates#update
#                                                       DELETE     /affiliates/:id(.:format)                                                          affiliates#destroy
#                                                  mcos GET        /mcos(.:format)                                                                    mcos#index
#                                                       POST       /mcos(.:format)                                                                    mcos#create
#                                               new_mco GET        /mcos/new(.:format)                                                                mcos#new
#                                              edit_mco GET        /mcos/:id/edit(.:format)                                                           mcos#edit
#                                                   mco GET        /mcos/:id(.:format)                                                                mcos#show
#                                                       PATCH      /mcos/:id(.:format)                                                                mcos#update
#                                                       PUT        /mcos/:id(.:format)                                                                mcos#update
#                                                       DELETE     /mcos/:id(.:format)                                                                mcos#destroy
#                              claim_calculation_export GET        /claim_calculations/:claim_calculation_id/export(.:format)                         claim_calculations#export
#                             search_claim_calculations GET        /claim_calculations/search(.:format)                                               claim_calculations#search
#                      update_address_claim_calculation POST       /claim_calculations/:id/update_address(.:format)                                   claim_calculations#update_address
#                         claim_calculation_claim_notes GET        /claim_calculations/:claim_calculation_id/claim_notes(.:format)                    claim_notes#index
#                                                       POST       /claim_calculations/:claim_calculation_id/claim_notes(.:format)                    claim_notes#create
#                      new_claim_calculation_claim_note GET        /claim_calculations/:claim_calculation_id/claim_notes/new(.:format)                claim_notes#new
#                     edit_claim_calculation_claim_note GET        /claim_calculations/:claim_calculation_id/claim_notes/:id/edit(.:format)           claim_notes#edit
#                          claim_calculation_claim_note GET        /claim_calculations/:claim_calculation_id/claim_notes/:id(.:format)                claim_notes#show
#                                                       PATCH      /claim_calculations/:claim_calculation_id/claim_notes/:id(.:format)                claim_notes#update
#                                                       PUT        /claim_calculations/:claim_calculation_id/claim_notes/:id(.:format)                claim_notes#update
#                                                       DELETE     /claim_calculations/:claim_calculation_id/claim_notes/:id(.:format)                claim_notes#destroy
#                                    claim_calculations GET        /claim_calculations(.:format)                                                      claim_calculations#index
#                                                       POST       /claim_calculations(.:format)                                                      claim_calculations#create
#                                 new_claim_calculation GET        /claim_calculations/new(.:format)                                                  claim_calculations#new
#                                edit_claim_calculation GET        /claim_calculations/:id/edit(.:format)                                             claim_calculations#edit
#                                     claim_calculation GET        /claim_calculations/:id(.:format)                                                  claim_calculations#show
#                                                       PATCH      /claim_calculations/:id(.:format)                                                  claim_calculations#update
#                                                       PUT        /claim_calculations/:id(.:format)                                                  claim_calculations#update
#                                                       DELETE     /claim_calculations/:id(.:format)                                                  claim_calculations#destroy
#                       import_contact_process_contacts POST       /contacts/import_contact_process(.:format)                                         contacts#import_contact_process
#                                              contacts GET        /contacts(.:format)                                                                contacts#index
#                                                       POST       /contacts(.:format)                                                                contacts#create
#                                           new_contact GET        /contacts/new(.:format)                                                            contacts#new
#                                          edit_contact GET        /contacts/:id/edit(.:format)                                                       contacts#edit
#                                               contact GET        /contacts/:id(.:format)                                                            contacts#show
#                                                       PATCH      /contacts/:id(.:format)                                                            contacts#update
#                                                       PUT        /contacts/:id(.:format)                                                            contacts#update
#                                                       DELETE     /contacts/:id(.:format)                                                            contacts#destroy
#                            parse_democ_detail_records POST       /democ_detail_records/parse(.:format)                                              democ_detail_records#parse
#                                  democ_detail_records DELETE     /democ_detail_records(.:format)                                                    democ_detail_records#destroy
#                                                       GET        /democ_detail_records(.:format)                                                    democ_detail_records#index
#                                                       POST       /democ_detail_records(.:format)                                                    democ_detail_records#create
#                               new_democ_detail_record GET        /democ_detail_records/new(.:format)                                                democ_detail_records#new
#                              edit_democ_detail_record GET        /democ_detail_records/:id/edit(.:format)                                           democ_detail_records#edit
#                                   democ_detail_record GET        /democ_detail_records/:id(.:format)                                                democ_detail_records#show
#                                                       PATCH      /democ_detail_records/:id(.:format)                                                democ_detail_records#update
#                                                       PUT        /democ_detail_records/:id(.:format)                                                democ_detail_records#update
#                                                       DELETE     /democ_detail_records/:id(.:format)                                                democ_detail_records#destroy
#                                  edit_individual_fees GET        /fees/edit_individual(.:format)                                                    fees#edit_individual
#                                update_individual_fees PUT        /fees/update_individual(.:format)                                                  fees#update_individual
#                                     fee_accounts_fees POST       /fees/fee_accounts(.:format)                                                       fees#fee_accounts
#                                                  fees GET        /fees(.:format)                                                                    fees#index
#                                                       POST       /fees(.:format)                                                                    fees#create
#                                               new_fee GET        /fees/new(.:format)                                                                fees#new
#                                              edit_fee GET        /fees/:id/edit(.:format)                                                           fees#edit
#                                                   fee GET        /fees/:id(.:format)                                                                fees#show
#                                                       PATCH      /fees/:id(.:format)                                                                fees#update
#                                                       PUT        /fees/:id(.:format)                                                                fees#update
#                                                       DELETE     /fees/:id(.:format)                                                                fees#destroy
#     final_policy_group_rating_and_premium_projections GET        /final_policy_group_rating_and_premium_projections(.:format)                       final_policy_group_rating_and_premium_projections#index
#                                                       POST       /final_policy_group_rating_and_premium_projections(.:format)                       final_policy_group_rating_and_premium_projections#create
#  new_final_policy_group_rating_and_premium_projection GET        /final_policy_group_rating_and_premium_projections/new(.:format)                   final_policy_group_rating_and_premium_projections#new
# edit_final_policy_group_rating_and_premium_projection GET        /final_policy_group_rating_and_premium_projections/:id/edit(.:format)              final_policy_group_rating_and_premium_projections#edit
#      final_policy_group_rating_and_premium_projection GET        /final_policy_group_rating_and_premium_projections/:id(.:format)                   final_policy_group_rating_and_premium_projections#show
#                                                       PATCH      /final_policy_group_rating_and_premium_projections/:id(.:format)                   final_policy_group_rating_and_premium_projections#update
#                                                       PUT        /final_policy_group_rating_and_premium_projections/:id(.:format)                   final_policy_group_rating_and_premium_projections#update
#                                                       DELETE     /final_policy_group_rating_and_premium_projections/:id(.:format)                   final_policy_group_rating_and_premium_projections#destroy
#                                         group_ratings GET        /group_ratings(.:format)                                                           group_ratings#index
#                                                       POST       /group_ratings(.:format)                                                           group_ratings#create
#                                      new_group_rating GET        /group_ratings/new(.:format)                                                       group_ratings#new
#                                     edit_group_rating GET        /group_ratings/:id/edit(.:format)                                                  group_ratings#edit
#                                          group_rating GET        /group_ratings/:id(.:format)                                                       group_ratings#show
#                                                       PATCH      /group_ratings/:id(.:format)                                                       group_ratings#update
#                                                       PUT        /group_ratings/:id(.:format)                                                       group_ratings#update
#                                                       DELETE     /group_ratings/:id(.:format)                                                       group_ratings#destroy
#                        group_rating_exception_resolve POST       /group_rating_exceptions/:group_rating_exception_id/resolve(.:format)              group_rating_exceptions#resolve
#                               group_rating_exceptions GET        /group_rating_exceptions(.:format)                                                 group_rating_exceptions#index
#                                                       POST       /group_rating_exceptions(.:format)                                                 group_rating_exceptions#create
#                            new_group_rating_exception GET        /group_rating_exceptions/new(.:format)                                             group_rating_exceptions#new
#                           edit_group_rating_exception GET        /group_rating_exceptions/:id/edit(.:format)                                        group_rating_exceptions#edit
#                                group_rating_exception GET        /group_rating_exceptions/:id(.:format)                                             group_rating_exceptions#show
#                                                       PATCH      /group_rating_exceptions/:id(.:format)                                             group_rating_exceptions#update
#                                                       PUT        /group_rating_exceptions/:id(.:format)                                             group_rating_exceptions#update
#                                                       DELETE     /group_rating_exceptions/:id(.:format)                                             group_rating_exceptions#destroy
#                                               imports DELETE     /imports(.:format)                                                                 imports#destroy
#                                   import_file_imports POST       /imports/import_file(.:format)                                                     imports#import_file
#                                  import_files_imports POST       /imports/import_files(.:format)                                                    imports#import_files
#                                                       GET        /imports(.:format)                                                                 imports#index
#                                                       POST       /imports(.:format)                                                                 imports#create
#                                            new_import GET        /imports/new(.:format)                                                             imports#new
#                                           edit_import GET        /imports/:id/edit(.:format)                                                        imports#edit
#                                                import GET        /imports/:id(.:format)                                                             imports#show
#                                                       PATCH      /imports/:id(.:format)                                                             imports#update
#                                                       PUT        /imports/:id(.:format)                                                             imports#update
#                                                       DELETE     /imports/:id(.:format)                                                             imports#destroy
# create_manual_class_objects_manual_class_calculations GET        /manual_class_calculations/create_manual_class_objects(.:format)                   manual_class_calculations#create_manual_class_objects
#                             manual_class_calculations GET        /manual_class_calculations(.:format)                                               manual_class_calculations#index
#                                                       POST       /manual_class_calculations(.:format)                                               manual_class_calculations#create
#                          new_manual_class_calculation GET        /manual_class_calculations/new(.:format)                                           manual_class_calculations#new
#                         edit_manual_class_calculation GET        /manual_class_calculations/:id/edit(.:format)                                      manual_class_calculations#edit
#                              manual_class_calculation GET        /manual_class_calculations/:id(.:format)                                           manual_class_calculations#show
#                                                       PATCH      /manual_class_calculations/:id(.:format)                                           manual_class_calculations#update
#                                                       PUT        /manual_class_calculations/:id(.:format)                                           manual_class_calculations#update
#                                                       DELETE     /manual_class_calculations/:id(.:format)                                           manual_class_calculations#destroy
#                 parse_mremp_employer_experience_index POST       /mremp_employer_experience/parse(.:format)                                         mremp_employer_experience#parse
#                       mremp_employer_experience_index DELETE     /mremp_employer_experience(.:format)                                               mremp_employer_experience#destroy
#                                                       GET        /mremp_employer_experience(.:format)                                               mremp_employer_experience#index
#                                                       POST       /mremp_employer_experience(.:format)                                               mremp_employer_experience#create
#                         new_mremp_employer_experience GET        /mremp_employer_experience/new(.:format)                                           mremp_employer_experience#new
#                        edit_mremp_employer_experience GET        /mremp_employer_experience/:id/edit(.:format)                                      mremp_employer_experience#edit
#                             mremp_employer_experience GET        /mremp_employer_experience/:id(.:format)                                           mremp_employer_experience#show
#                                                       PATCH      /mremp_employer_experience/:id(.:format)                                           mremp_employer_experience#update
#                                                       PUT        /mremp_employer_experience/:id(.:format)                                           mremp_employer_experience#update
#                                                       DELETE     /mremp_employer_experience/:id(.:format)                                           mremp_employer_experience#destroy
#                             parse_mrcl_detail_records POST       /mrcl_detail_records/parse(.:format)                                               mrcl_detail_records#parse
#                                   mrcl_detail_records DELETE     /mrcl_detail_records(.:format)                                                     mrcl_detail_records#destroy
#                                                       GET        /mrcl_detail_records(.:format)                                                     mrcl_detail_records#index
#                                                       POST       /mrcl_detail_records(.:format)                                                     mrcl_detail_records#create
#                                new_mrcl_detail_record GET        /mrcl_detail_records/new(.:format)                                                 mrcl_detail_records#new
#                               edit_mrcl_detail_record GET        /mrcl_detail_records/:id/edit(.:format)                                            mrcl_detail_records#edit
#                                    mrcl_detail_record GET        /mrcl_detail_records/:id(.:format)                                                 mrcl_detail_records#show
#                                                       PATCH      /mrcl_detail_records/:id(.:format)                                                 mrcl_detail_records#update
#                                                       PUT        /mrcl_detail_records/:id(.:format)                                                 mrcl_detail_records#update
#                                                       DELETE     /mrcl_detail_records/:id(.:format)                                                 mrcl_detail_records#destroy
#                                           parse_index DELETE     /parse(.:format)                                                                   parse#destroy
#                                                       GET        /parse(.:format)                                                                   parse#index
#                                                       POST       /parse(.:format)                                                                   parse#create
#                                             new_parse GET        /parse/new(.:format)                                                               parse#new
#                                            edit_parse GET        /parse/:id/edit(.:format)                                                          parse#edit
#                                                 parse GET        /parse/:id(.:format)                                                               parse#show
#                                                       PATCH      /parse/:id(.:format)                                                               parse#update
#                                                       PUT        /parse/:id(.:format)                                                               parse#update
#                                                       DELETE     /parse/:id(.:format)                                                               parse#destroy
#                                  payroll_calculations GET        /payroll_calculations(.:format)                                                    payroll_calculations#index
#                                                       POST       /payroll_calculations(.:format)                                                    payroll_calculations#create
#                               new_payroll_calculation GET        /payroll_calculations/new(.:format)                                                payroll_calculations#new
#                              edit_payroll_calculation GET        /payroll_calculations/:id/edit(.:format)                                           payroll_calculations#edit
#                                   payroll_calculation GET        /payroll_calculations/:id(.:format)                                                payroll_calculations#show
#                                                       PATCH      /payroll_calculations/:id(.:format)                                                payroll_calculations#update
#                                                       PUT        /payroll_calculations/:id(.:format)                                                payroll_calculations#update
#                                                       DELETE     /payroll_calculations/:id(.:format)                                                payroll_calculations#destroy
#                            parse_pcomb_detail_records POST       /pcomb_detail_records/parse(.:format)                                              pcomb_detail_records#parse
#                                  pcomb_detail_records DELETE     /pcomb_detail_records(.:format)                                                    pcomb_detail_records#destroy
#                                                       GET        /pcomb_detail_records(.:format)                                                    pcomb_detail_records#index
#                                                       POST       /pcomb_detail_records(.:format)                                                    pcomb_detail_records#create
#                               new_pcomb_detail_record GET        /pcomb_detail_records/new(.:format)                                                pcomb_detail_records#new
#                              edit_pcomb_detail_record GET        /pcomb_detail_records/:id/edit(.:format)                                           pcomb_detail_records#edit
#                                   pcomb_detail_record GET        /pcomb_detail_records/:id(.:format)                                                pcomb_detail_records#show
#                                                       PATCH      /pcomb_detail_records/:id(.:format)                                                pcomb_detail_records#update
#                                                       PUT        /pcomb_detail_records/:id(.:format)                                                pcomb_detail_records#update
#                                                       DELETE     /pcomb_detail_records/:id(.:format)                                                pcomb_detail_records#destroy
#                            parse_phmgn_detail_records POST       /phmgn_detail_records/parse(.:format)                                              phmgn_detail_records#parse
#                                  phmgn_detail_records DELETE     /phmgn_detail_records(.:format)                                                    phmgn_detail_records#destroy
#                                                       GET        /phmgn_detail_records(.:format)                                                    phmgn_detail_records#index
#                                                       POST       /phmgn_detail_records(.:format)                                                    phmgn_detail_records#create
#                               new_phmgn_detail_record GET        /phmgn_detail_records/new(.:format)                                                phmgn_detail_records#new
#                              edit_phmgn_detail_record GET        /phmgn_detail_records/:id/edit(.:format)                                           phmgn_detail_records#edit
#                                   phmgn_detail_record GET        /phmgn_detail_records/:id(.:format)                                                phmgn_detail_records#show
#                                                       PATCH      /phmgn_detail_records/:id(.:format)                                                phmgn_detail_records#update
#                                                       PUT        /phmgn_detail_records/:id(.:format)                                                phmgn_detail_records#update
#                                                       DELETE     /phmgn_detail_records/:id(.:format)                                                phmgn_detail_records#destroy
#             create_policy_objects_policy_calculations GET        /policy_calculations/create_policy_objects(.:format)                               policy_calculations#create_policy_objects
#                            search_policy_calculations GET        /policy_calculations/search(.:format)                                              policy_calculations#search
#                 policy_calculation_claim_calculations GET        /policy_calculations/:policy_calculation_id/claim_calculations(.:format)           claim_calculations#index
#                                                       POST       /policy_calculations/:policy_calculation_id/claim_calculations(.:format)           claim_calculations#create
#              new_policy_calculation_claim_calculation GET        /policy_calculations/:policy_calculation_id/claim_calculations/new(.:format)       claim_calculations#new
#             edit_policy_calculation_claim_calculation GET        /policy_calculations/:policy_calculation_id/claim_calculations/:id/edit(.:format)  claim_calculations#edit
#                  policy_calculation_claim_calculation GET        /policy_calculations/:policy_calculation_id/claim_calculations/:id(.:format)       claim_calculations#show
#                                                       PATCH      /policy_calculations/:policy_calculation_id/claim_calculations/:id(.:format)       claim_calculations#update
#                                                       PUT        /policy_calculations/:policy_calculation_id/claim_calculations/:id(.:format)       claim_calculations#update
#                                                       DELETE     /policy_calculations/:policy_calculation_id/claim_calculations/:id(.:format)       claim_calculations#destroy
#                                   policy_calculations GET        /policy_calculations(.:format)                                                     policy_calculations#index
#                                                       POST       /policy_calculations(.:format)                                                     policy_calculations#create
#                                new_policy_calculation GET        /policy_calculations/new(.:format)                                                 policy_calculations#new
#                               edit_policy_calculation GET        /policy_calculations/:id/edit(.:format)                                            policy_calculations#edit
#                                    policy_calculation GET        /policy_calculations/:id(.:format)                                                 policy_calculations#show
#                                                       PATCH      /policy_calculations/:id(.:format)                                                 policy_calculations#update
#                                                       PUT        /policy_calculations/:id(.:format)                                                 policy_calculations#update
#                                                       DELETE     /policy_calculations/:id(.:format)                                                 policy_calculations#destroy
#                      policy_coverage_status_histories GET        /policy_coverage_status_histories(.:format)                                        policy_coverage_status_histories#index
#                                                       POST       /policy_coverage_status_histories(.:format)                                        policy_coverage_status_histories#create
#                    new_policy_coverage_status_history GET        /policy_coverage_status_histories/new(.:format)                                    policy_coverage_status_histories#new
#                   edit_policy_coverage_status_history GET        /policy_coverage_status_histories/:id/edit(.:format)                               policy_coverage_status_histories#edit
#                        policy_coverage_status_history GET        /policy_coverage_status_histories/:id(.:format)                                    policy_coverage_status_histories#show
#                                                       PATCH      /policy_coverage_status_histories/:id(.:format)                                    policy_coverage_status_histories#update
#                                                       PUT        /policy_coverage_status_histories/:id(.:format)                                    policy_coverage_status_histories#update
#                                                       DELETE     /policy_coverage_status_histories/:id(.:format)                                    policy_coverage_status_histories#destroy
#                              policy_program_histories GET        /policy_program_histories(.:format)                                                policy_program_histories#index
#                                                       POST       /policy_program_histories(.:format)                                                policy_program_histories#create
#                            new_policy_program_history GET        /policy_program_histories/new(.:format)                                            policy_program_histories#new
#                           edit_policy_program_history GET        /policy_program_histories/:id/edit(.:format)                                       policy_program_histories#edit
#                                policy_program_history GET        /policy_program_histories/:id(.:format)                                            policy_program_histories#show
#                                                       PATCH      /policy_program_histories/:id(.:format)                                            policy_program_histories#update
#                                                       PUT        /policy_program_histories/:id(.:format)                                            policy_program_histories#update
#                                                       DELETE     /policy_program_histories/:id(.:format)                                            policy_program_histories#destroy
#                             program_rejection_resolve POST       /program_rejections/:program_rejection_id/resolve(.:format)                        program_rejections#resolve
#                                    program_rejections GET        /program_rejections(.:format)                                                      program_rejections#index
#                                                       POST       /program_rejections(.:format)                                                      program_rejections#create
#                                 new_program_rejection GET        /program_rejections/new(.:format)                                                  program_rejections#new
#                                edit_program_rejection GET        /program_rejections/:id/edit(.:format)                                             program_rejections#edit
#                                     program_rejection GET        /program_rejections/:id(.:format)                                                  program_rejections#show
#                                                       PATCH      /program_rejections/:id(.:format)                                                  program_rejections#update
#                                                       PUT        /program_rejections/:id(.:format)                                                  program_rejections#update
#                                                       DELETE     /program_rejections/:id(.:format)                                                  program_rejections#destroy
#                             quote_group_rating_report GET        /quotes/:quote_id/group_rating_report(.:format)                                    quotes#group_rating_report
#                                 quote_accounts_quotes POST       /quotes/quote_accounts(.:format)                                                   quotes#quote_accounts
#                            edit_quote_accounts_quotes GET        /quotes/edit_quote_accounts(.:format)                                              quotes#edit_quote_accounts
#                        generate_account_quotes_quotes POST       /quotes/generate_account_quotes(.:format)                                          quotes#generate_account_quotes
#                              delete_all_quotes_quotes DELETE     /quotes/delete_all_quotes(.:format)                                                quotes#delete_all_quotes
#                         quote_view_group_rating_quote GET        /quotes/:quote_id/view_group_rating_quote(.:format)                                quotes#view_group_rating_quote
#                          quote_view_group_retro_quote GET        /quotes/:quote_id/view_group_retro_quote(.:format)                                 quotes#view_group_retro_quote
#                                    quote_view_invoice GET        /quotes/:quote_id/view_invoice(.:format)                                           quotes#view_invoice
#                                 quote_new_group_retro GET        /quotes/:quote_id/new_group_retro(.:format)                                        quotes#new_group_retro
#                              quote_create_group_retro POST       /quotes/:quote_id/create_group_retro(.:format)                                     quotes#create_group_retro
#                              test_client_packet_quote GET        /quotes/:id/test_client_packet(.:format)                                           quotes#test_client_packet
#                            test_prospect_packet_quote GET        /quotes/:id/test_prospect_packet(.:format)                                         quotes#test_prospect_packet
#                        test_retro_client_packet_quote GET        /quotes/:id/test_retro_client_packet(.:format)                                     quotes#test_retro_client_packet
#                      test_retro_prospect_packet_quote GET        /quotes/:id/test_retro_prospect_packet(.:format)                                   quotes#test_retro_prospect_packet
#                                                quotes GET        /quotes(.:format)                                                                  quotes#index
#                                                       POST       /quotes(.:format)                                                                  quotes#create
#                                             new_quote GET        /quotes/new(.:format)                                                              quotes#new
#                                            edit_quote GET        /quotes/:id/edit(.:format)                                                         quotes#edit
#                                                 quote GET        /quotes/:id(.:format)                                                              quotes#show
#                                                       PATCH      /quotes/:id(.:format)                                                              quotes#update
#                                                       PUT        /quotes/:id(.:format)                                                              quotes#update
#                                                       DELETE     /quotes/:id(.:format)                                                              quotes#destroy
#               representative_all_account_group_rating GET        /representatives/:representative_id/all_account_group_rating(.:format)             representatives#all_account_group_rating
#                          representative_start_process GET        /representatives/:representative_id/start_process(.:format)                        representatives#start_process
#                       representative_users_management GET        /representatives/:representative_id/users_management(.:format)                     representatives#users_management
#                       representative_fee_calculations POST       /representatives/:representative_id/fee_calculations(.:format)                     representatives#fee_calculations
#                  representative_export_manual_classes GET        /representatives/:representative_id/export_manual_classes(.:format)                representatives#export_manual_classes
#                        representative_export_policies GET        /representatives/:representative_id/export_policies(.:format)                      representatives#export_policies
#                        representative_export_accounts GET        /representatives/:representative_id/export_accounts(.:format)                      representatives#export_accounts
#              representative_export_159_request_weekly POST       /representatives/:representative_id/export_159_request_weekly(.:format)            representatives#export_159_request_weekly
#       representative_filter_export_159_request_weekly GET        /representatives/:representative_id/filter_export_159_request_weekly(.:format)     representatives#filter_export_159_request_weekly
#                       representative_import_tpa_dates POST       /representatives/:representative_id/import_tpa_dates(.:format)                     representatives#import_tpa_dates
#                 representative_import_contact_process POST       /representatives/:representative_id/import_contact_process(.:format)               representatives#import_contact_process
#                 representative_import_payroll_process POST       /representatives/:representative_id/import_payroll_process(.:format)               representatives#import_payroll_process
#                   representative_import_claim_process POST       /representatives/:representative_id/import_claim_process(.:format)                 representatives#import_claim_process
#           representative_import_account_notes_process POST       /representatives/:representative_id/import_account_notes_process(.:format)         representatives#import_account_notes_process
#             representative_import_claim_notes_process POST       /representatives/:representative_id/import_claim_notes_process(.:format)           representatives#import_claim_notes_process
#   representative_import_employer_demographics_process POST       /representatives/:representative_id/import_employer_demographics_process(.:format) representatives#import_employer_demographics_process
#                      representative_all_quote_process GET        /representatives/:representative_id/all_quote_process(.:format)                    representatives#all_quote_process
#                               representative_zip_file POST       /representatives/:representative_id/zip_file(.:format)                             representatives#zip_file
#                      representative_edit_global_dates GET        /representatives/:representative_id/edit_global_dates(.:format)                    representatives#edit_global_dates
#            purge_representative_employer_demographics POST       /representatives/:representative_id/employer_demographics/purge(.:format)          employer_demographics#purge
#                  representative_employer_demographics GET        /representatives/:representative_id/employer_demographics(.:format)                employer_demographics#index
#                      delete_everything_representative POST       /representatives/:id/delete_everything(.:format)                                   representatives#delete_everything
#                                       representatives GET        /representatives(.:format)                                                         representatives#index
#                                                       POST       /representatives(.:format)                                                         representatives#create
#                                    new_representative GET        /representatives/new(.:format)                                                     representatives#new
#                                   edit_representative GET        /representatives/:id/edit(.:format)                                                representatives#edit
#                                        representative GET        /representatives/:id(.:format)                                                     representatives#show
#                                                       PATCH      /representatives/:id(.:format)                                                     representatives#update
#                                                       PUT        /representatives/:id(.:format)                                                     representatives#update
#                                                       DELETE     /representatives/:id(.:format)                                                     representatives#destroy
#                                 representatives_users GET        /representatives_users(.:format)                                                   representatives_users#index
#                                                       POST       /representatives_users(.:format)                                                   representatives_users#create
#                              new_representatives_user GET        /representatives_users/new(.:format)                                               representatives_users#new
#                             edit_representatives_user GET        /representatives_users/:id/edit(.:format)                                          representatives_users#edit
#                                  representatives_user GET        /representatives_users/:id(.:format)                                               representatives_users#show
#                                                       PATCH      /representatives_users/:id(.:format)                                               representatives_users#update
#                                                       PUT        /representatives_users/:id(.:format)                                               representatives_users#update
#                                                       DELETE     /representatives_users/:id(.:format)                                               representatives_users#destroy
#                     parse_sc220_employer_demographics POST       /sc220_employer_demographics/parse(.:format)                                       sc220_employer_demographics#parse
#                           sc220_employer_demographics DELETE     /sc220_employer_demographics(.:format)                                             sc220_employer_demographics#destroy
#                                                       GET        /sc220_employer_demographics(.:format)                                             sc220_employer_demographics#index
#                                                       POST       /sc220_employer_demographics(.:format)                                             sc220_employer_demographics#create
#                        new_sc220_employer_demographic GET        /sc220_employer_demographics/new(.:format)                                         sc220_employer_demographics#new
#                       edit_sc220_employer_demographic GET        /sc220_employer_demographics/:id/edit(.:format)                                    sc220_employer_demographics#edit
#                            sc220_employer_demographic GET        /sc220_employer_demographics/:id(.:format)                                         sc220_employer_demographics#show
#                                                       PATCH      /sc220_employer_demographics/:id(.:format)                                         sc220_employer_demographics#update
#                                                       PUT        /sc220_employer_demographics/:id(.:format)                                         sc220_employer_demographics#update
#                                                       DELETE     /sc220_employer_demographics/:id(.:format)                                         sc220_employer_demographics#destroy
#                     parse_sc230_employer_demographics POST       /sc230_employer_demographics/parse(.:format)                                       sc230_employer_demographics#parse
#                           sc230_employer_demographics DELETE     /sc230_employer_demographics(.:format)                                             sc230_employer_demographics#destroy
#                                                       GET        /sc230_employer_demographics(.:format)                                             sc230_employer_demographics#index
#                                                       POST       /sc230_employer_demographics(.:format)                                             sc230_employer_demographics#create
#                        new_sc230_employer_demographic GET        /sc230_employer_demographics/new(.:format)                                         sc230_employer_demographics#new
#                       edit_sc230_employer_demographic GET        /sc230_employer_demographics/:id/edit(.:format)                                    sc230_employer_demographics#edit
#                            sc230_employer_demographic GET        /sc230_employer_demographics/:id(.:format)                                         sc230_employer_demographics#show
#                                                       PATCH      /sc230_employer_demographics/:id(.:format)                                         sc230_employer_demographics#update
#                                                       PUT        /sc230_employer_demographics/:id(.:format)                                         sc230_employer_demographics#update
#                                                       DELETE     /sc230_employer_demographics/:id(.:format)                                         sc230_employer_demographics#destroy
#                                      new_user_session GET        /users/sign_in(.:format)                                                           users/sessions#new
#                                          user_session POST       /users/sign_in(.:format)                                                           users/sessions#create
#                                  destroy_user_session DELETE     /users/sign_out(.:format)                                                          users/sessions#destroy
#                                         user_password POST       /users/password(.:format)                                                          devise/passwords#create
#                                     new_user_password GET        /users/password/new(.:format)                                                      devise/passwords#new
#                                    edit_user_password GET        /users/password/edit(.:format)                                                     devise/passwords#edit
#                                                       PATCH      /users/password(.:format)                                                          devise/passwords#update
#                                                       PUT        /users/password(.:format)                                                          devise/passwords#update
#                                                 users GET        /users(.:format)                                                                   users#index
#                                                       POST       /users(.:format)                                                                   users#create
#                                              new_user GET        /users/new(.:format)                                                               users#new
#                                             edit_user GET        /users/:id/edit(.:format)                                                          users#edit
#                                                  user GET        /users/:id(.:format)                                                               users#show
#                                                       PATCH      /users/:id(.:format)                                                               users#update
#                                                       PUT        /users/:id(.:format)                                                               users#update
#                                                       DELETE     /users/:id(.:format)                                                               users#destroy
#                                           create_user POST       /create_user(.:format)                                                             users#create
#                                              versions GET        /versions(.:format)                                                                versions#index
#                                                       POST       /versions(.:format)                                                                versions#create
#                                           new_version GET        /versions/new(.:format)                                                            versions#new
#                                          edit_version GET        /versions/:id/edit(.:format)                                                       versions#edit
#                                               version GET        /versions/:id(.:format)                                                            versions#show
#                                                       PATCH      /versions/:id(.:format)                                                            versions#update
#                                                       PUT        /versions/:id(.:format)                                                            versions#update
#                                                       DELETE     /versions/:id(.:format)                                                            versions#destroy
#                                         welcome_index GET        /welcome(.:format)                                                                 welcome#index
#                                                       POST       /welcome(.:format)                                                                 welcome#create
#                                           new_welcome GET        /welcome/new(.:format)                                                             welcome#new
#                                          edit_welcome GET        /welcome/:id/edit(.:format)                                                        welcome#edit
#                                               welcome GET        /welcome/:id(.:format)                                                             welcome#show
#                                                       PATCH      /welcome/:id(.:format)                                                             welcome#update
#                                                       PUT        /welcome/:id(.:format)                                                             welcome#update
#                                                       DELETE     /welcome/:id(.:format)                                                             welcome#destroy
#                                        payroll_manage GET        /manage/payroll(.:format)                                                          manage#payroll
#                            non_updated_payroll_manage GET        /manage/non_updated_payroll(.:format)                                              manage#non_updated_payroll
#                                          payroll_diff GET        /manage/payroll_diff(.:format)                                                     manage#payroll_diff
#                                      payroll_diff_ids GET        /manage/payroll_diff_ids(.:format)                                                 manage#payroll_diff_ids
#                                            claim_diff GET        /manage/claim_diff(.:format)                                                       manage#claim_diff
#                                                 rates GET        /manage/rates(.:format)                                                            rates#index
#                                                       POST       /manage/rates(.:format)                                                            rates#create
#                                              new_rate GET        /manage/rates/new(.:format)                                                        rates#new
#                                             edit_rate GET        /manage/rates/:id/edit(.:format)                                                   rates#edit
#                                                  rate GET        /manage/rates/:id(.:format)                                                        rates#show
#                                                       PATCH      /manage/rates/:id(.:format)                                                        rates#update
#                                                       PUT        /manage/rates/:id(.:format)                                                        rates#update
#                                                       DELETE     /manage/rates/:id(.:format)                                                        rates#destroy
#                                 claim_note_categories GET        /manage/claim_note_categories(.:format)                                            claim_note_categories#index
#                                                       POST       /manage/claim_note_categories(.:format)                                            claim_note_categories#create
#                               new_claim_note_category GET        /manage/claim_note_categories/new(.:format)                                        claim_note_categories#new
#                              edit_claim_note_category GET        /manage/claim_note_categories/:id/edit(.:format)                                   claim_note_categories#edit
#                                   claim_note_category GET        /manage/claim_note_categories/:id(.:format)                                        claim_note_categories#show
#                                                       PATCH      /manage/claim_note_categories/:id(.:format)                                        claim_note_categories#update
#                                                       PUT        /manage/claim_note_categories/:id(.:format)                                        claim_note_categories#update
#                                                       DELETE     /manage/claim_note_categories/:id(.:format)                                        claim_note_categories#destroy
#                                       note_categories GET        /manage/note_categories(.:format)                                                  note_categories#index
#                                                       POST       /manage/note_categories(.:format)                                                  note_categories#create
#                                     new_note_category GET        /manage/note_categories/new(.:format)                                              note_categories#new
#                                    edit_note_category GET        /manage/note_categories/:id/edit(.:format)                                         note_categories#edit
#                                         note_category GET        /manage/note_categories/:id(.:format)                                              note_categories#show
#                                                       PATCH      /manage/note_categories/:id(.:format)                                              note_categories#update
#                                                       PUT        /manage/note_categories/:id(.:format)                                              note_categories#update
#                                                       DELETE     /manage/note_categories/:id(.:format)                                              note_categories#destroy
#                                            max_losses GET        /manage/max-losses(.:format)                                                       bwc_codes_credibility_max_losses#index
#                                     update_max_losses POST       /manage/max_losses(.:format)                                                       bwc_codes_credibility_max_losses#update_losses
#                                                manage GET        /manage(.:format)                                                                  manage#index
#                                        manual_classes GET        /manual-classes(.:format)                                                          bwc_annual_manual_class_changes#index
#                                                       POST       /manual-classes(.:format)                                                          bwc_annual_manual_class_changes#create
#                                      new_manual_class GET        /manual-classes/new(.:format)                                                      bwc_annual_manual_class_changes#new
#                                     edit_manual_class GET        /manual-classes/:id/edit(.:format)                                                 bwc_annual_manual_class_changes#edit
#                                          manual_class GET        /manual-classes/:id(.:format)                                                      bwc_annual_manual_class_changes#show
#                                                       PATCH      /manual-classes/:id(.:format)                                                      bwc_annual_manual_class_changes#update
#                                                       PUT        /manual-classes/:id(.:format)                                                      bwc_annual_manual_class_changes#update
#                                                       DELETE     /manual-classes/:id(.:format)                                                      bwc_annual_manual_class_changes#destroy
#                                                  root GET        /                                                                                  welcome#index
#                                 internal_server_error            /500(.:format)                                                                     errors#internal_server_error
#                                        page_not_found            /404(.:format)                                                                     errors#page_not_found

require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Sidekiq::Web, at: '/sidekiq'

  resources :accounts do
    get :edit_group_rating
    get :edit_group_retro
    post :group_rating_calc
    post :group_retro_calc
    post :group_rating
    post :assign
    post :assign_address
    get :risk_report
    post :claim_loss_export
    get :ranged_claim_loss_export
    post :ranged_claim_loss_export_form
    get :new_risk_report
    get :retention
    get :roc_report
    post :group_rating_calculation

    resources :notes do
      delete :remove_attachment

      member do
        patch :update_pinned
      end
    end

    resources :affiliates

    collection do
      post :import_account_process
      get :autocomplete_policy_number_entered
    end
  end

  resources :account_programs do
    collection { post :import_account_program_process }
    collection { put :update_individual }
  end

  resources :affiliates do
    collection { post :import_affiliate_process }
  end

  resources :mcos

  resources :claim_calculations do
    get :export

    collection do
      get :search
    end

    member do
      post :update_address
    end

    resources :claim_notes
  end

  resources :contacts do
    collection { post :import_contact_process }
  end

  resources :democ_detail_records do
    collection { post :parse }
    collection { delete :destroy }
  end

  resources :fees do
    collection { get :edit_individual }
    collection { put :update_individual }
    collection { post :fee_accounts }
  end

  resources :final_policy_group_rating_and_premium_projections

  resources :group_ratings

  resources :group_rating_exceptions do
    post :resolve
  end

  resources :imports do
    collection do
      delete :destroy
      post :import_file
      post :import_files
    end
  end

  resources :manual_class_calculations do
    collection { get 'create_manual_class_objects' }
  end

  resources :mremp_employer_experience do
    collection { post :parse }
    collection { delete :destroy }
  end

  resources :mrcl_detail_records do
    collection { post :parse }
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy }
  end

  resources :payroll_calculations

  resources :pcomb_detail_records do
    collection { post :parse }
    collection { delete :destroy }
  end

  resources :phmgn_detail_records do
    collection { post :parse }
    collection { delete :destroy }
  end

  resources :policy_calculations do
    collection do
      get 'create_policy_objects'
      get :search
    end

    resources :claim_calculations
  end

  resources :policy_coverage_status_histories

  resources :policy_program_histories

  resources :program_rejections do
    post :resolve
  end

  resources :quotes do
    get :group_rating_report
    collection { post :quote_accounts }
    collection { get :edit_quote_accounts }
    collection { post :generate_account_quotes }
    collection { delete :delete_all_quotes }
    get :view_group_rating_quote
    get :view_group_retro_quote
    get :view_invoice
    get :new_group_retro
    post :create_group_retro

    member do
      get :test_client_packet
      get :test_prospect_packet
      get :test_retro_client_packet
      get :test_retro_prospect_packet
    end
  end

  resources :representatives do
    get :all_account_group_rating
    get :start_process
    get :users_management
    post :fee_calculations
    get :export_manual_classes
    get :export_policies
    get :export_accounts
    post :export_159_request_weekly
    get :filter_export_159_request_weekly
    post :import_tpa_dates
    post :import_contact_process
    post :import_payroll_process
    post :import_claim_process
    post :import_account_notes_process
    post :import_claim_notes_process
    get :all_quote_process
    post :zip_file
    get :edit_global_dates

    member do
      post :delete_everything
    end
  end

  resources :employer_demographics, only: :index, path: 'employer-demographics' do
    collection do
      post :purge
      post :import
    end
  end

  resources :representatives_users

  resources :sc220_employer_demographics do
    collection { post :parse }
    collection { delete :destroy }
  end

  resources :sc230_employer_demographics do
    collection { post :parse }
    collection { delete :destroy }
  end

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    confirmations: 'users/confirmations'
  }

  resources :users
  post 'create_user', to: 'users#create', as: :create_user

  resources :versions

  resources :welcome

  scope :manage do
    get :payroll, to: 'manage#payroll', as: :payroll_manage
    get :non_updated_payroll, to: 'manage#non_updated_payroll', as: :non_updated_payroll_manage
    get :payroll_diff, to: 'manage#payroll_diff', as: :payroll_diff
    get :payroll_diff_ids, to: 'manage#payroll_diff_ids', as: :payroll_diff_ids
    get :claim_diff, to: 'manage#claim_diff', as: :claim_diff
    resources :rates
    resources :claim_note_categories
    resources :note_categories
    get 'max-losses', to: 'bwc_codes_credibility_max_losses#index', as: :max_losses
    post 'max_losses', to: 'bwc_codes_credibility_max_losses#update_losses', as: :update_max_losses
  end

  get 'manage', to: 'manage#index', as: :manage

  resources :bwc_annual_manual_class_changes, path: 'manual-classes', as: :manual_classes

  root 'welcome#index'

  match "500", to: 'errors#internal_server_error', as: :internal_server_error, via: :all
  match "404", to: 'errors#page_not_found', as: :page_not_found, via: :all
end
