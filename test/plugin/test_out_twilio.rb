require 'helper'

class TwilioOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    account_sid  TWILIO_ACCOUNT_SID
    auth_token   TWILIO_AUTH_TOKEN
    from_number  +8112345678
  ]

  def create_driver(conf=CONFIG,tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::TwilioOutput, tag).configure(conf)
  end

  def test_configure
    assert_raise(Fluent::ConfigError) {
      d = create_driver('')
    }
    d = create_driver %[
      account_sid  TWILIO_ACCOUNT_SID
      auth_token   TWILIO_AUTH_TOKEN
      from_number  +8112345678
    ]
    assert_equal 'TWILIO_ACCOUNT_SID', d.instance.account_sid
    assert_equal 'TWILIO_AUTH_TOKEN', d.instance.auth_token
    assert_equal '+8112345678', d.instance.from_number
  end

  def test_configure_multinumber
    d = create_driver %[
      account_sid  TWILIO_ACCOUNT_SID
      auth_token   TWILIO_AUTH_TOKEN
      from_number  +8112345678
      default_number  +81123456789,+811234567890
    ]
    assert_equal 'TWILIO_ACCOUNT_SID', d.instance.account_sid
    assert_equal 'TWILIO_AUTH_TOKEN', d.instance.auth_token
    assert_equal '+8112345678', d.instance.from_number
    assert_equal '+81123456789,+811234567890', d.instance.default_number
  end


  def test_emit
    d1 = create_driver(CONFIG, 'notify.call')
    d1.run do
      d1.emit({'message' => 'hello world.'})
    end
    emits = d1.emits
    assert_equal 0, emits.length
  end
end

