# /sIT/Service/Provisioning/StateMachines/Methods/rename_service
#----------------------------------------------------------------
# CFME Automate Method: rename_service
# Author: Klaus Wagner
#
# Notes: This method renames the service based on the dialog options passed
#----------------------------------------------------------------
begin
  service_template_provision_task = $evm.root['service_template_provision_task']
  service = service_template_provision_task.destination
  
  dialog_options = service_template_provision_task.dialog_options
  $evm.log("info","#{@method} - Inspecting Dialog Options:<#{dialog_options.inspect}>")
  
  # Set Name
  if dialog_options.has_key? 'dialog_service_name'
    service.name = dialog_options['dialog_service_name'].to_s
  end
  
  # Set Description
  if dialog_options.has_key? 'dialog_service_description'
    service.description = dialog_options['dialog_service_description'].to_s
  end

  $evm.log("info", "#{@method} - EVM Automate Method Ended: service.name='#{service.name.to_s}', service.description='#{service.description}'")
  exit MIQ_OK
rescue => err
  $evm.log("error", "#{@method} - [#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_ABORT
end
