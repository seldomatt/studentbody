require 'sqlite3'
require 'sinatra'
require 'fileutils'

class StudentBody < Sinatra::Base 

  get '/' do
    @indexed_students
    erb :index
  end

  get '/:fullname' do 
    @student = Student.find(params[:fullname])
    erb :profile
  end


  class Student

    

    @db = SQLite3::Database.open('db/studentbody.db')

    @db.results_as_hash = true
    
    keys = @db.execute("SELECT * FROM students").first.map do |key, value|
      key.to_sym if key.class == String
    end

    @@attributes = keys.compact!
    
    @@attributes.each do |attribute|
      attr_accessor attribute
    end

    
    def self.find(fullname)
      first_name, last_name = fullname.split("-",2)
      student = Student.new
      @db.results_as_hash = true
      result = @db.execute("SELECT * FROM students WHERE first_name = '#{first_name.capitalize}' AND last_name = '#{last_name.capitalize}'")[0]
      @@attributes.each do |attribute|
        student.send("#{attribute}=", result[attribute.to_s])
      end
      student
    end
  
  end

end

StudentBody.run!