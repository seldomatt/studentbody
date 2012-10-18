require 'sinatra'
require 'sqlite3'
require 'fileutils'

class StudentBody < Sinatra::Base

class Student
  attr_accessor :id, :name, :email

  @@students = [{:id => 1, :name => "matt", :email => "seldomatt@gmail.com"},
                          {:id => 2, :name => "li", :email => "li.ouyang@gmail.com"}]

   @db = SQLite3::Database.open('pickpokit.db')
   # puts @db.execute("select * from students")

  # def import
  #   @db.execute("SELECT id, first_name FROM students") do |row|
  #       @@students[:student][:id] = row[0]
  #       @@students[:student][:first_name] = row[1]
  #   end
  # end

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
    self.all.select{|student| student[:id] == id.to_i }[0]
  end

end

get '/:id' do
  @student = Student.find(params[:id].to_i)
  erb :profile
end

end


StudentBody.run!



