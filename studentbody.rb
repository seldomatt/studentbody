require 'sinatra'
# require 'sqlite3'

class StudentBody < Sinatra::Base

class Student
  attr_accessor :id, :name, :email
  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end

end

get '/:id' do
  @student = Student.new(params[:id], "liouyang", "email")
  erb :profile
end

end


StudentBody.run!


