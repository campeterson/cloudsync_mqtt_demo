require 'mqtt'
require 'uri'

# CloudMQTT URL is passed as an arg

ENV['CLOUDMQTT_URL'] = ARGV[0]
data_topic = "account/+/licenses/+/data"

# Create a hash with the connection parameters from the URL
uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}

MQTT::Client.connect(conn_opts) do |c|
  # The block will be called when messages arrive to the topic
  c.get(data_topic) do |topic, message|
    puts "#{topic}: #{message}"
  end
end
