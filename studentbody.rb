require 'sqlite3'
require 'sinatra'
require 'fileutils'

class StudentBody < Sinatra::Base

  get '/:id' do
    @student = Student.find(params[:id])
    erb :profile
  end


  class Student

    @db = SQLite3::Database.open('db/studentbody.db')
    @db.results_as_hash = true

   keys = @db.execute("SELECT * FROM students").first.map do |key, value|
      key.to_sym if key.class == String
   end
   @@attributes = keys.compact!

   @@attributes.each do |a|
    attr_accessor a
  end

    def self.find(id)
      student = Student.new
      @db.results_as_hash = true
      result = @db.execute("SELECT * FROM students WHERE id = #{id}")[0]
      @@attributes.each do |attribute|
        student.send("#{attribute}=", result[attribute.to_s])
      end
      student
    end

  end

end

StudentBody.run!
