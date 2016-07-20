# SmsApi

Simple gem responsible for connecting to smsapi.pl and sending simple smses.
Version 0.1 supports only sending sms.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sms_api_pl', :git => 'git://github.com/marcinwierzbicki/sms_api_pl.git'
```

And then execute:

    $ bundle


Add configuration file to initializers:

```ruby
SmsApi.setup do |config|
  config.username   = "login to smsapi.pl page"
  config.password   = "password to smsapi.pl page"
  config.test_mode  = Rails.env.production? ? false : true
end
```

## Usage

```ruby
sms = SmsApi::SMS.new(:to => "555-555-555", :message => "Lorem Ipsum", :from => "Alert")
sms.deliver! # Then raise an error if failure
# or
sms.deliver # Return false on failure
```

For more please read [SmsApi.pl](http://smsapi.pl) documentation at [link](http://www.smsapi.pl/sms-api/interfejs-https)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
