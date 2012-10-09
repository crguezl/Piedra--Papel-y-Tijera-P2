require 'sinatra'
require 'erb'

# before we process a route we'll set the response as plain text
# and set up an array of viable moves that a player (and the
# computer) can perform
before do
  @defeat = { piedra: :tijera, papel: :piedra, tijera: :papel}
  @throws = @defeat.keys
end

get '/' do
  erb :vista_inicial
end
 
get '/*' do
  redirect '/'
end

post '/throw' do
 	# the params hash stores querystring and form data
	if params[:type]== nil
		halt erb :error
	else
  		@player_throw = params[:type].to_sym
  end

  @computer_throw = @throws.sample

  if @player_throw == @computer_throw 
    @answer = "EMPATE"
    erb :index
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Has perdido -->  #{@computer_throw}  gana a #{@player_throw}"
    erb :index
  else
    @answer = "Has ganado --> #{@player_throw}  gana a  #{@computer_throw}"
    erb :index
  end
end
