require 'discordrb'
require './controller/diceController.rb'
require 'dotenv'
Dotenv.load '.env.token'
Dotenv.load '.env.client'
 
bot = Discordrb::Commands::CommandBot.new token: ENV['token'],
                                          client_id: ENV['client_id'],
                                          prefix: '/'


bot.command :connect, description: 'bot connect you voice channel.' do |event|
  bot.voice_connect(event.user.voice_channel)
end

bot.command :play, description: 'If you say \"/play file_name.mp3\", I\'ll play \'file_name.mp3\'' do |event, path|
  file_path = 'bgm/' + path
  if !File.exist?(file_path)
    event.respond "Sorry, file not found."
  else
    voice_bot = event.voice
    voice_bot.play_file(file_path)
  end
end

bot.command :setgame, description: 'If you say \"/setgame Ruina\", I start playing \"Ruina\"' do |event, game|
  bot.game = game.to_s
  nil
end

bot.command :coc, description: 'roll d100 percent roll. \"/coc 50 spothidden\"' do |event, percent, skillname|
  case
  when percent == "character" then
    coccharacter(event)
  when percent.to_i > 0 then
    cocroll(event, percent.to_i, skillname)
  end
end

@users = {}
bot.command :plot, description: 'plot on shinobigami.' do |event, plotNum, name|
  plot(event, plotNum, name)
end

bot.message do |event|
  diceroll(event)
end
bot.run
