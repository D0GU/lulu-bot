require "discordrb"

module Oneshot
    extend Discordrb::Commands::CommandContainer
  
    command :ily do |event|
        author = event.message.author.display_name
        event.respond("Auu?.. I love you too #{author}...")
    end
  end