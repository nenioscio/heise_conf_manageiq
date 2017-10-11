#----------------------------------------------------------------
#
# CFME Automate Method: set_service
#
# Author: Klaus Wagner
#
# Notes: This method moves the VM to a different service
#
#----------------------------------------------------------------

begin  
  def get_target_by_dialog
    target_service_id = $evm.root['dialog_service_id']
    return $evm.vmdb('service').find_by_id(target_service_id)
  end 
  
  def move_vm_to_service(vm, target_service)
    unless vm.service.nil?
      $evm.log(:info, "Removing vm '#{vm.name}' from service_id : #{vm.service.id}")
      vm.remove_from_service()
    else
      $evm.log(:info, "Vm '#{vm.name}' had no service assigned")
    end
    $evm.log(:info, "Adding vm '#{vm.name}' to service #{target_service.name} with id : #{target_service.id}")
    vm.add_to_service(target_service)
  end
  
  target_service = get_target_by_dialog()
  
  case $evm.root['vmdb_object_type']
  when 'service_template_provision_task'
    service_template_provision_task = $evm.root['service_template_provision_task']
    service_template_provision_task.miq_request_tasks.each do |child_task|
      #
      # Process grandchild task service options
      #
      unless child_task.miq_request_tasks.nil?
        child_task.miq_request_tasks.each do |grandchild_task|
          prov = grandchild_task         
          move_vm_to_service(prov.destination, target_service)
        end
      end
    end
  when 'vm'
    vm = $evm.root['vm']                # called from a button
    move_vm_to_service(vm, target_service)
  end

  exit MIQ_OK
rescue => err
  $evm.log(:error, "[#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_STOP
end
