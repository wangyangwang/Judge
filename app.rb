require 'sinatra'
require 'dm-core'
require 'dm-validations'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})


class Proposition
  include DataMapper::Resource
  property :id, Serial
  property :time, DateTime
  property :nickname, String 
  property :body, Text 
  property :agree, Integer
  property :disagree, Integer
  
  validates_presence_of :nickname
  validates_presence_of :body
end

DataMapper.finalize


get '/' do
  
  @posts = Proposition.all(:order => [ :id.desc ])
  @title = "Judge"
  
  erb :index
end


get '/newpost' do
  
  @title = "Judge - New Post"
  erb :newpost
end

post '/save' do
  
  @title = "Judge - Save Post"
  @message = ""
  
  newPost = Proposition.new
  newPost.nickname = params[:nickname]
  newPost.body = params[:postbody] 
  newPost.agree = '0'
  newPost.disagree = '0'
  newPost.time = Time.now
  
  
  
  @currentNickname = newPost.nickname
  
  if(newPost.save)
    @message = "Thanks " + @currentNickname + ", your proposition was saved"
  else
    @message = "Sorry " + @currentNickname + ", your proposition was NOT SAVED, please complete the form"
  end
  
  erb :savepost
end


post '/:id' do
  
  
 
  @prop = Proposition.get(params[:id])
  currentAgreeValue = @prop.agree
  currentDisagreeValue = @prop.disagree

  @post = Proposition.get(params[:id])
  @currentVote = params[:judge]
  @voted = ""
  
  if (@currentVote == "agree")
    @voted = "AGREE" 
    @prop = Proposition.get(params[:id])
    currentValue = @prop.agree
    newValue = currentValue + 1
    @prop.update(:agree => newValue)
    
  elsif (@currentVote == "disagree")
    @voted = "DISAGREE"
    @prop = Proposition.get(params[:id])
    currentValue = @prop.disagree
    newValue = currentValue + 1
    @prop.update(:disagree => newValue)
  end
  
  erb :post
end

