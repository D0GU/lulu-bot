require "discordrb"
require "sequel"
require 'discordrb/webhooks'
require "json"


module Proxy
    extend Discordrb::EventContainer
    extend Discordrb::Commands::CommandContainer
  
    command :proxy_create do |event,prefix,*text|
        name = text.join(' ')
        image = event.message.attachments[0].url.to_s
        $PROXIES.insert(:name => name, :prefix => prefix, :pfp => image)
        puts image
    end

    command :proxy_delete do |event,*text|
        name = text.join(' ')
        $PROXIES.filter(:name => name).delete
        event.respond("Proxy for #{name} has been deleted")
    end
    
    command :proxy_prefix do |event,prefix,*text|
        name = text.join(' ')
        $PROXIES.where(:name => name).update(prefix: prefix)
        event.respond("Prefix for #{name} has been changed to #{prefix}")
    end

    message do |event|
        for item in $PROXIES.all{|row|}
            if event.message.content.start_with? item[:prefix]
                channel_id = event.message.channel.id
                puts "Bot "+TOKEN.to_s,channel_id.to_s,item[:name].to_s,item[:pfp]
                response = Discordrb::API::Channel.create_webhook("Bot "+TOKEN.to_s,channel_id.to_s,item[:name].to_s,item[:pfp])
                data = JSON.load(response)
                puts response
                builder1 = Discordrb::Webhooks::Client.new(id: data["id"],token: data["token"])
                builder1.execute do |builder|
                    builder.content = event.message.content.reverse.chomp(item[:prefix].reverse).reverse
                    builder.username = item[:name]
                    builder.avatar_url = item[:pfp]
                
                end
                Discordrb::API::Webhook.delete_webhook("Bot "+TOKEN, data["id"])
                event.message.delete 
            end
        end
    end
end


