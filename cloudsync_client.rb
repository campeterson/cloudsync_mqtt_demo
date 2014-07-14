require 'mqtt'
require 'uri'

# CloudMQTT URL is passed as an arg

ENV['CLOUDMQTT_URL'] = ARGV[0]
account_id = ARGV[1]
license_id = ARGV[2]

account_topic = "accounts/#{account_id}"
license_topic = "accounts/#{account_id}/licenses/#{license_id}"
data_topic = "account/#{account_id}/licenses/#{license_id}/data"

# Create a hash with the connection parameters from the URL
uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}

# Subscribe to Account Topic
Thread.new do
  MQTT::Client.connect(conn_opts) do |c|
    # The block will be called when messages arrive to the topic
    c.get(account_topic) do |topic, message|
      puts "#{topic}: #{message}"
    end
  end
end

# Subscribe to License Topic
Thread.new do
  MQTT::Client.connect(conn_opts) do |c|
    # The block will be called when messages arrive to the topic
    c.get(license_topic) do |topic, message|
      puts "#{topic}: #{message}"
    end
  end
end

MQTT::Client.connect(conn_opts) do |c|
  # publish a message to the topic 'test'
  loop do
    message = ["PrintJob", "CutJob", "OpenFile", "CreateIcc"].sample
    c.publish(data_topic, message)
    #puts message
    sleep 1
  end
end
