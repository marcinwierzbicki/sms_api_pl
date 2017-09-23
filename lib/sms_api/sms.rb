require 'net/http'
require 'uri'

module SmsApi
  class SMS
    # Available options to pass in constructor
    # This options you can use to send in params
    AVAILABLE_OPTIONS = [:password, :username, :from, :to, :group, :message, :from, :encoding, :flash, :test,
                         :details, :date, :datacodin, :idx, :check_idx, :single, :eco, :nounicode, :fast]

    # Required field for sending sms
    REQUIRED_FIELDS = [:from, :password, :username, :to, :message]

    attr_accessor *AVAILABLE_OPTIONS, :passed_options

    def initialize(*args)
      options = args.extract_options!.symbolize_keys!
      options.merge!(username: (options[:username] || SmsApi.username),
                     password: (options[:password] || SmsApi.password),
                     test: SmsApi.test_mode)

      options.each_pair do |opt_key, opt_val|
        if AVAILABLE_OPTIONS.include?(opt_key)
          self.send("#{opt_key}=", opt_val)
        else
          raise ArgumentError, "There is no option: #{opt_key}. Please check documentation."
        end
      end

      # Encode password and save in instance variable
      self.password = Digest::MD5.hexdigest(options[:password])

      # We are saving information about which options were passed
      self.passed_options = options.keys

      self
    end

    def post_form(url, params)
      req = Net::HTTP::Post.new(url)
      req.form_data = params
      req.basic_auth url.user, url.password if url.user
      Net::HTTP.start(url.hostname, url.port,
            :use_ssl => url.scheme == 'https', :p_addr = :ENV, :p_port => :ENV) {|http|
        http.request(req)
      }
    end

    def deliver!
      validate_sms

      SmsApi::Phone.validate_phone_number(@to)

      # Sending sms to smsapi.pl
      response = post_form(URI.parse(SmsApi.sms_api_url), generate_params).body

      # Checking response. If is an error then we are raising exception
      # other wise we return array [:ID, :POINTS]
      # where ID is an sms ID and POINTS is cost of an sms
      if response.match(/^ERROR:(\d+)$/)
        raise DeliverError, $1
      elsif response.match(/^OK:(.+):(.+)$/)
        [$1, $2]
      else
        raise DeliverError, "Unknow response."
      end
    end

    # Sends a sms and return false if something goes wrong
    def deliver
      begin
        deliver!
        true
      rescue DeliverError, InvalidPhoneNumberNumeraticly, InvalidPhoneNumberLength,
             InvalidPhoneNumber, InvalidSmsPropertis => e
        false
      end
    end

    private
    # Validate presence of required fields
    def validate_sms
      REQUIRED_FIELDS.each do |field|
        if self.send(field) == nil || self.send(field) == ""
          raise InvalidSmsPropertis, "Option #{field} is unset. This field is required."
        end
      end
      true
    end

    # Return hash of options which was set.
    def generate_params
      result = {}

      passed_options.each do |opt|
        result[opt] = self.send(opt)
      end

      # Setting up test option
      self.test ? result[:test] = 1 : result.delete(:test)

      result
    end
  end
end

class InvalidSmsPropertis < StandardError; end;
class DeliverError < StandardError
  def initialize(status)
    super(SmsApi::Mappings::ERRORS.keys.include?(status.to_i) ? SmsApi::Mappings::ERRORS[status.to_i] : status)
  end
end
