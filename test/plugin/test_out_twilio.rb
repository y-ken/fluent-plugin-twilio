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

  def create_driver(conf=CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::TwilioOutput).configure(conf)
  end

  def test_configure
    assert_raise(Fluent::ConfigError) {
      d = create_driver('')
    }
    d = create_driver %[
      account_sid     TWILIO_ACCOUNT_SID
      auth_token      TWILIO_AUTH_TOKEN
      from_number     +8112345678
      default_message test_message
    ]
    assert_equal 'TWILIO_ACCOUNT_SID', d.instance.account_sid
    assert_equal 'TWILIO_AUTH_TOKEN', d.instance.auth_token
    assert_equal '+8112345678', d.instance.from_number
    assert_equal 'test_message', d.instance.default_message
  end

  def test_configure_multinumber
    d = create_driver %[
      account_sid     TWILIO_ACCOUNT_SID
      auth_token      TWILIO_AUTH_TOKEN
      from_number     +8112345678
      default_number  +81123456789,+811234567890
      default_message test_message
    ]
    assert_equal 'TWILIO_ACCOUNT_SID', d.instance.account_sid
    assert_equal 'TWILIO_AUTH_TOKEN', d.instance.auth_token
    assert_equal '+8112345678', d.instance.from_number
    assert_equal '+81123456789,+811234567890', d.instance.default_number
    assert_equal 'test_message', d.instance.default_message
  end


  def test_emit
    d1 = create_driver(CONFIG)
    d1.run(default_tag: 'notify.call') do
      d1.feed({'message' => 'hello world.'})
    end
    events = d1.events
    assert_equal 0, events.length
  end
end

