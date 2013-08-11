fluentd-plugin-twilio
=====================

## Overview
Fluentd Output plugin to make a call with twilio.

## Installation

### native gem
`````
gem install fluentd-plugin-twilio
`````

### td-agent gem
`````
/usr/lib64/fluent/ruby/bin/fluent-gem install fluentd-plugin-twilio
`````

## Configuration

### Message Format
`````
fluent_logger.post('notify.call', {
  :message  => 'Hello World!',   # Required
  :number   => '+8109012345678'  # Required
})
`````

### Sample
`````
<source>
  type http
  port 8888
</source>

<match notify.call>
  type twilio
  account_sid     TWILIO_ACCOUNT_SID  # Required
  auth_token      TWILIO_AUTH_TOKEN   # Required
  from_number     +81312345678        # Required with country code
  default_number  090-1234-5678       # Optional
</match>
`````

### Quick Test
`````
# test call to +819012345678 and say "Help! System ABC has down." with woman voice.
$ curl http://localhost:8888/notify.call -F 'json={"number":"+819012345678","voice":"woman","message":"Help! System ABC has down."}'

# check twilio activity log
$ tail -f /var/log/td-agent/td-agent.log
`````

## Backend Service

* Twilio https://www.twilio.com/
* Twilio Japan http://twilio.kddi-web.com/

## Blog Articles

* http://y-ken.hatenablog.com/entry/fluent-plugin-twilio-has-released

## TODO
Pull requests are very welcome!!

## Copyright
Copyright © 2013- Kentaro Yoshida ([@yoshi_ken](https://twitter.com/yoshi_ken))

## License
Apache License, Version 2.0

