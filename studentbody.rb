require 'sqlite3'
require 'sinatra'
require 'fileutils'

class StudentBody < Sinatra::Base 

  get '/:id' do 
    @student = Student.find(params[:id])
    erb :profile
  end


  class Student
    attr_accessor :id, :name, :email

    @@students = [{:id => 1, :name => "Matt", :email => "matthewsalern@gmail.com"}, 
                  {:id => 2, :name => "Li", :email => "li.ouyang@gmail.com"}]

    @db = SQLite3::Database.open('db/studentbody.db')

    def self.all
      @@students
    end

    def self.find(id)
      @db.results_as_hash = true
      @db.execute("SELECT * FROM students WHERE id = #{id}")[0]
    end
  
  end

end

StudentBody.run!