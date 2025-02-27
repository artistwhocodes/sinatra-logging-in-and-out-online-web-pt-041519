require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
      @user = User.find_by(username: params[:username]) #instance will equal hash input from form
      if @user && @user.password == params[:password]   #does the user name and password equal the database one?
        session[:user_id] = @user.id   #then this session will equal that user id!
        redirect to '/account'   # go back to account page
      end
      erb :"error"
  end

  get '/account' do
     @user = Helpers.is_logged_in?(session) #check to see if user is logged in
     if @user == true #if they are then
       erb :account  #show their account
     else
       erb :error      #else show error page.
     end
   end

  get '/logout' do
      session.clear  #clear hash
      redirect to '/'
  end


end
