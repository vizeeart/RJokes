#!usr/bin/env ruby
# encoding: UTF-8

__author__ = "VIZEE ART"

require 'net/http'
require 'json'
require 'whirly'
require 'tty-prompt'
require 'tty-box'

banner = '
 ____           _  ____  _  __ _____
/  __\         / |/  _ \/ |/ //  __/
|  \/|_____    | || / \||   / |  \  
|    /\____\/\_| || \_/||   \ |  /_ 
\_/\_\      \____/\____/\_|\_\\____\

          RANDOM JOKES     V1.0
'

def fetch_joke
  uri = URI('https://official-joke-api.appspot.com/random_joke')
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

def display_joke(joke)
  joke_box = TTY::Box.frame(
    width: 40,
    height: 10,
    align: :center,
    padding: 1
  ) do
    "#{joke['setup']}\n\n#{joke['punchline']}"
  end

  puts joke_box
end

def main
  prompt = TTY::Prompt.new

  Whirly.start(spinner: 'dots', status: 'Fetching a random joke...') do
    joke = fetch_joke
    sleep 1
    display_joke(joke)
  end

  loop do
    choice = prompt.select('What would you like to do?', %w(Get_Next_Joke Exit))

    case choice
    when 'Get_Next_Joke'
      Whirly.start(spinner: 'dots', status: 'Fetching a random joke...') do
        joke = fetch_joke
        sleep 1
        display_joke(joke)
      end
    when 'Exit'
      break
    end
  end
end

puts banner
main
