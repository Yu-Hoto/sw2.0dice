require 'discordrb'
require './controller/diceController.rb'
require 'dotenv'
Dotenv.load '.env.token'
Dotenv.load '.env.client'
 
bot = Discordrb::Commands::CommandBot.new token: ENV['token'],
                                          client_id: ENV['client_id'],
                                          prefix: '/'

bot.command :play, description: 'If you say \"/play file_name.mp3\", I\'ll play \'file_name.mp3\'' do |event, path|
  file_path = 'bgm/' + path
  if !File.exist?(file_path)
    event.respond "Sorry, file not found."
  else
    voice_bot = bot.voice_connect event.user.voice_channel
    voice_bot.play_file(file_path)
    voice_bot.destroy
  end
  nil
end

bot.command :setgame, description: 'If you say \"/setgame Ruina\", I start playing \"Ruina\"' do |event, game|
  bot.game = game.to_s
  nil
end

bot.command :coc, description: 'roll d100 percent roll. \"/coc 50 spothidden\"' do |event, percent, skillname|
  cocroll(event, percent.to_i, skillname)
end

bot.message do |event|
  diceroll(event)
end
bot.run
