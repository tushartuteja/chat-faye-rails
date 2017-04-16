require 'rest-client'
class ChatController < ApplicationController
  before_action :authenticate_user!
  def index
  	@messages = Message.all
  end

  def new_message
  	message = params[:message]
  	@message = current_user.messages.create(:content => message)
	respond_to do |format|
		format.js{
			data = Hash.new
			data["user"] = current_user.email
			data["content"] = message
			message = {:channel => "/messages/new", :data => data}
			response = RestClient.post("http://localhost:9292/faye", message.to_json, "content-type":"application/json")
			# uri = URI.parse("http://localhost:9292/faye")
			# Net::HTTP.post_form(uri, :message => message.to_json)
		}
	end  	
  end

end
