require "sms_api/version"
require "sms_api/phone"
require "sms_api/sms"
require "sms_api/vms"
require "sms_api/mappings"

module SmsApi
  # SmsApi account credentials
  mattr_accessor :username
  mattr_accessor :password

  # Turn on/off testmode
  mattr_accessor :test_mode
  @@test_mode = false

  # Address of smsapi.pl
  mattr_accessor :sms_api_url
  mattr_accessor :vms_api_url
  @@sms_api_url = "http://api.smsapi.pl/sms.do"
  @@vms_api_url = "http://api.smsapi.pl/vms.do"


  # Needed for configuration file
  def self.setup
    yield self
  end
end
