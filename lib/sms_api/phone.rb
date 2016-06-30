require 'net/http'
require 'uri'

module SmsApi
  class Phone 

    # Valides phone number in poland
    # Correct phone numbers are: 
    # (+48) 790 111 146
    # (48) 790 111 146
    # (+48)-790-111-146
    # (48)-790-111-146
    # +48 790 111 146
    # +48 790-111-146
    # 48 790 111 146
    # 48 790-111-146
    # 790 111 146
    # 790-111-146
    # +48790111146
    def self.validate_phone_number(to)
      avaliable_length  = [9, 11] # Without or with country prefix
      phone_number      = to.gsub(/\s|\-|\+|\.|\(|\)/, '')

      if not avaliable_length.include?(phone_number.size)
        raise InvalidPhoneNumberLength, "Please check phone number: #{to}." 
      elsif phone_number.length == 11 && !phone_number.match(/^48/)
        raise InvalidPhoneNumber, "Wrong phone format: #{to}."
      elsif phone_number.match(/[A-Za-z]/)
        raise InvalidPhoneNumberNumeraticly, "Phone number contains letters: #{to}." 
      end
      
      true
    end

  end
end

class InvalidPhoneNumberNumeraticly < StandardError; end;
class InvalidPhoneNumberLength < StandardError; end;
class InvalidPhoneNumber < StandardError; end;
