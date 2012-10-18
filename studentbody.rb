require 'sqlite3'
require 'sinatra'

class StudentBody < Sinatra::Base 

	get '/:id' do 
		@student = Student.find(params[:id])
		erb :profile
	end






	class Student
		attr_accessor :id, :name, :email

		@@students = [{:id => 1, :name => "Matt", :email => "matthewsalern@gmail.com"}, 
									{:id => 2, :name => "Li", :email => "li.ouyang@gmail.com"}]

		def initialize(id, name, email)
			@id = id
			@name = name
			@email = email
			@@students << self
		end

		def self.all
			@@students
		end

		def self.find(id)
			array = self.all.select {|student| student[:id] == id.to_i}
			array[0]
		end

	end

end

StudentBody.run!