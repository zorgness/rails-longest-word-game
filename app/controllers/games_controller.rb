# frozen_string_literal: true

require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    p @letters.class
    score_and_message = score_and_message(@word, @letters)
    @score = score_and_message.first
    @message = score_and_message.last
  end

  def score_and_message(word, letters)
    if included?(word.upcase, letters)
      if english_word?(word)
        score = compute_score(word)
        [score, "Congratulations! #{word.upcase} is a valid English word"]
      else
        [0, "Sorry but #{word.upcase} does not seem to be an english word"]
      end
    else
      [0, "Sorry but #{word.upcase} can't be build from #{letters.tr('[]', '').gsub('"', ' ')}"]
    end
  end

  def compute_score(word)
    word.size
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
