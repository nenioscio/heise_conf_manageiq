#----------------------------------------------------------------
#
# CFME Automate Method: eligible_service_list
#
# Author: Klaus Wagner
#
# Notes: This method populates a dynamic drop-down list of services
#
#----------------------------------------------------------------

begin
  values_hash         = {}
  eligible_catalog_id = $evm.vmdb('service_template').where('name = ?', 'Create new Service').first.id
  available_services  = $evm.vmdb('service').where('service_template_id = ?', eligible_catalog_id)
  
  $evm.log(:info, "Found: #{available_services.map{|s| s.name}}")
  if available_services.length > 0
    if available_services.length > 1
      values_hash['!'] = '-- select from list --'
    end

    available_services.each do |service|
      values_hash[service.id] = service.name
    end
  else
    values_hash['!'] = 'No service assigned to your group! Please create using the service catalog.'
  end

  list_values = {
      'sort_by'    => :value,
      'data_type'  => :string,
      'required'   => true,
      'values'     => values_hash
  }
  list_values.each { |key, value| $evm.object[key] = value }
  
  exit MIQ_OK
rescue => err
  $evm.log(:error, "[#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_STOP
end
