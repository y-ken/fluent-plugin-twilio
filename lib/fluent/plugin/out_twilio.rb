class Fluent::TwilioOutput < Fluent::Output
  Fluent::Plugin.register_output('twilio', self)

  config_param :account_sid, :string
  config_param :auth_token, :string
  config_param :from_number, :string, :default => ''
  config_param :default_number, :string, :default => ''
  config_param :default_voice, :string, :default => 'woman'
  config_param :language, :string, :default => 'ja-jp'

  VOICE_MAP = ['man', 'woman']

  # Define `log` method for v0.10.42 or earlier
  unless method_defined?(:log)
    define_method("log") { $log }
  end

  def initialize
    super
    require 'uri'
    require 'twilio-ruby'
  end

  def configure(conf)
    super

  end

  def emit(tag, es, chain)
    es.each do |time,record|
      number = record['number'].nil? ? @default_number : record['number']
      @voice = VOICE_MAP.include?(record['voice']) ? record['voice'] : @default_voice
      call(number, record['message'])
    end

    chain.next
  end

  def call(number, message)
    response = Twilio::TwiML::Response.new do |r|
      r.Say message, :voice => @voice, :language => @language
    end
    xml = response.text.sub(/<[^>]+?>/, '')
    url = "http://twimlets.com/echo?Twiml=#{URI.escape(xml)}"
    log.info "twilio: generateing twiml: #{xml}"

    client = Twilio::REST::Client.new(@account_sid, @auth_token)
    account = client.account
    number.gsub(' ', '').split(',').each do |to_number|
      begin
        call = account.calls.create({:from => @from_number, :to => to_number, :url => url})
      rescue => e
        log.error "twilio: Error: #{e.message}"
      end
    end
  end
end

