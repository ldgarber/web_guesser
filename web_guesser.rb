require 'sinatra'
require 'sinatra/reloader'

class Guesser
    @@secret_number = rand(100)
    @@guesses = 5

def secret_number
    @@secret_number
end

def guesses=(guesses)
    @@guesses = guesses
end

def self.guesses
    @@guesses
end

def reset_secret_number
    @@secret_number = rand(100)
end

def check_guess(guess)
    guess = guess.to_i
    if guess > @@secret_number
        if guess - @@secret_number > 5
            message = "Way too high!"
        else
            message = "Too high!"
        end
    elsif guess < @@secret_number
        if @@secret_number - guess > 5
            message =  "Way too low!"
        else
            message = "Too low!"
        end
    else
        message = "You got it right! \n The SECRET NUMBER is #{@@secret_number}."
    end

    return message
end

def adjust_guesses(guess)
    guess = guess.to_i
    if guess != @@secret_number
        @@guesses -= 1
        if @@guesses == 0
            message2 = "Out of guesses, generating a new number."
            @@secret_number = rand(100)
            @@guesses = 5
        else
            message2 = "#{@@guesses} guesses remaining"
        end
    else
        @@guesses = 5
        @@secret_number = rand(100)
        message2 = "#{@@guesses} guesses remaining to guess new number."
    end
    return message2
end

def assign_color(message)
    if message == "Way too high!" || message == "Way too low!"
        color = "#DB3548"
    elsif message == "Too high!" ||  message == "Too low!"
        color = "#FF8C8C"
    else
        color = "#33CC33"
    end
    return color
end
end

wg = Guesser.new
get '/' do
    guess = params[:guess]
    cheat = params[:cheat]
    message2 = ""
    if guess
        message = wg.check_guess(guess)
        color = wg.assign_color(message)
        message2 = wg.adjust_guesses(guess)
    else
        wg.guesses = 5
        wg.reset_secret_number
        message = "Guess the number from 0-100 in 5 guesses!"
        color = "#35DBC8"
    end
    if cheat
        cheatmessage = "(Psst. It's #{wg.secret_number})"
    else
        cheatmessage = ""
    end
    erb :index, :locals => {:message => message, :color => color, :message2 => message2, :cheatmessage => cheatmessage}

end
