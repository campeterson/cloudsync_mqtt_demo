require 'mqtt'
require 'uri'

# CloudMQTT URL is passed as an arg

ENV['CLOUDMQTT_URL'] = ARGV[0]
account_id = ARGV[1]

#licenses = ["0000001", "0000002"]
#license_id = ARGV[2]
#account_topic = "accounts/#{account_id}"
#license_topic = "accounts/#{account_id}/licenses/#{license_id}"

# Create a hash with the connection parameters from the URL
uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}

def generate_message(account_id)
  # Choose a message
  message = ["Welcome to Flexi", "Your license is expiring", "An update is available"].sample
  topic = ["accounts/#{account_id}/licenses/0000001", "accounts/#{account_id}/licenses/0000002", "accounts/#{account_id}"].sample
  return topic, message
end

MQTT::Client.connect(conn_opts) do |c|
  loop do
    # Choose who to send to
    topic, message = generate_message(account_id)
    c.publish(topic, message)
    puts "Sent message: #{message} to #{topic}"
    sleep 1
  end
end
