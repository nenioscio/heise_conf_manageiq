#----------------------------------------------------------------
#
# CFME Automate Method: eligible_description
#
# Author: Klaus Wagner
#
# Notes: This method populates a dynamic textarea with lorem ipsum data
#
#----------------------------------------------------------------


require 'rest-client'

def query_lorem_ipsum()
  url="https://loripsum.net/api/1/plaintext"

  request = RestClient::Request.new(
    :method => :get,
    :url => url,
  )

  $evm.log(:info, "query_lorem_ipsum() request url: #{request.url}")
  begin
    return request.execute
  rescue Exception, NameError => exception
    $evm.log(:warn, "Exception calling query_lorem_ipsum: \nmessage: #{exception.message}\nbacktrace: #{exception.backtrace}")
    return exception.message
  end
end


$evm.object['value'] = query_lorem_ipsum().to_s

exit MIQ_OK
