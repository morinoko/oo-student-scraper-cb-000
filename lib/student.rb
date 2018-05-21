class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

  @@all = []

  def initialize( student_hash )

    # creates a self.attribute=(value) method for each data attribute passed in
    # e.g. self.twitter = value
    student_hash.each do |attribute, value|
      self.send( ( "#{attribute}=" ), value )
    end

    @@all << self
  end

  # Create new students with data scraped by the Scraper
  def self.create_from_collection( students_array )
    students_array.each do |student|
      self.new( student )
    end
  end

  # Add additional attributes to a student using data scraped from the profile page
  def add_student_attributes( attributes_hash )
    attributes_hash.each do |attribute, value|
      self.send( ( "#{attribute}=" ), value)
    end
    self
  end

  def self.all
    @@all
  end
end
