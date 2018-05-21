require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page( index_url )
    index_page = create_nokogiri_doc( index_url )

    # Create array holding a list of hashes that contain
    # the name, location, and profile_url for each student on the index page
    all_students = index_page.css( ".student-card" )

    data_from_index_page = all_students.collect do |student|
      student_data = {
        :name => student.css( ".card-text-container .student-name" ).text,
        :location => student.css( ".card-text-container .student-location" ).text,
        :profile_url => student.css( "a" ).attribute( "href" ).value
      }
    end

    data_from_index_page
  end

  # Create a hash returning data for an individual student
  # Account for when student does not have a particular social profile
  def self.scrape_profile_page( profile_url )
    profile_page = create_nokogiri_doc( profile_url )
    student_data = {}

    social_links = profile_page.css( ".social-icon-container a" ).collect { |link| link.attribute( "href" ).value }

    # Loop through social link url and assign to appropriate data variable
    # according to the content of the link
    if !social_links.empty?
      social_links.each do |link|
        if link =~ /twitter/
          student_data[ :twitter ] = link
        elsif link =~ /linkedin/
          student_data[ :linkedin ] = link
        elsif link =~ /github/
          student_data[ :github ] = link
        else
          student_data[ :blog ] = link
        end
      end
    end

    student_data[ :profile_quote ] = profile_page.css( ".vitals-text-container .profile-quote" ).text
    student_data[ :bio ] = profile_page.css( ".bio-content .description-holder p" ).text

    student_data
  end

  private

  def self.create_nokogiri_doc( url )
    Nokogiri::HTML( open( url ) )
  end

end
