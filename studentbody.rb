require 'sqlite3'
require 'sinatra'

class StudentBody < Sinatra::Base 

	get '/:id' do 
		@student = Student.new(params[:id], "Matt Salerno", "matthewsalern@gmail.com")
		erb :profile
	end






	class Student
		attr_accessor :id, :name, :email

		def initialize(id, name, email)
			@id = id
			@name = name
			@email = email
		end
	end

end

StudentBody.run!