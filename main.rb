require "dotenv/load"
require "discordrb"
require "sequel"
require_relative "database.rb"
require_relative "oneshot.rb"
require_relative "proxy.rb"

if File.exists?('.env') != true
    File.open('.env', 'w+') do |env|

        File.write(env,"PREFIX=$\nTOKEN=\nCLIENT_ID=\nSECRET=")
    end
    abort "new .env file created, please enter your bot client id and token and restart server"    
end

Dotenv.load
PREFIX = ENV['PREFIX']
TOKEN = ENV['TOKEN']
CLIENT_ID = ENV['CLIENT_ID']
SECRET = ENV['SECRET']

database_init

$bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID, prefix: PREFIX
$bot.include! Oneshot
$bot.include! Proxy
$bot.run

