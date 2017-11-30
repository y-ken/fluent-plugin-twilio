require 'uri'
require 'twilio-ruby'

require 'fluent/plugin/output'

class Fluent::Plugin::TwilioOutput < Fluent::Plugin::Output
  Fluent::Plugin.register_output('twilio', self)

  config_param :account_sid, :string
  config_param :auth_token, :string, secret: true
  config_param :from_number, :string, default: ''
  config_param :default_number, :string, default: ''
  config_param :default_voice, :string, default: 'woman'
  config_param :default_message, :string, default: nil
  config_param :language, :string, default: 'ja-jp'

  VOICE_MAP = ['man', 'woman']

  def configure(conf)
    super

  end

  def process(tag, es)
    es.each do |time,record|
      number = record['number'].nil? ? @default_number : record['number']
      @voice = VOICE_MAP.include?(record['voice']) ? record['voice'] : @default_voice
      message = record['message'] || @default_message
      call(number, message)
    end
  end

  def call(number, message)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message, voice: @voice, language: @language)
    end
    xml = response.to_s.sub(/<[^>]+?>/, '')
    url = "http://twimlets.com/echo?Twiml=#{URI.escape(xml)}"
    log.info "twilio: generateing twiml: #{xml}"

    client = Twilio::REST::Client.new(@account_sid, @auth_token)
    account = client.api.account
    number.gsub(' ', '').split(',').each do |to_number|
      begin
        account.calls.create(from: @from_number, to: to_number, url: url)
      rescue => e
        log.error "twilio: Error: #{e.message}"
      end
    end
  end
end

