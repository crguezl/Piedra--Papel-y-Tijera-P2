require 'sinatra'
require 'erb'

configure do
  enable :sessions
end

# before we process a route we'll set the response as plain text
# and set up an array of viable moves that a player (and the
# computer) can perform
before do
  @defeat = { piedra: :tijera, papel: :piedra, tijera: :papel}
  @throws = @defeat.keys
end

get '/' do
	session[:empate] = 0 unless session[:empate]
	session[:computer] = 0 unless session[:computer]
	session[:jugador] = 0 unless session[:jugador]
  puts " Jugador: #{session[:jugador]}"
  puts " Ordenador: #{session[:computer]}"
  puts " Empate: #{session[:empate]}"
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
		session[:empate] += 1 
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Has perdido -->  #{@computer_throw}  gana a #{@player_throw}"
	session[:computer] += 1
  else
    @answer = "Has ganado --> #{@player_throw}  gana a  #{@computer_throw}"
	session[:jugador] += 1

  end
erb :index
end
