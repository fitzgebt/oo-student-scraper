require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    student_profile = Nokogiri::HTML(html)
    hash_array = []
    hash = {}
    student_profile.css("div.student-card").each do |item|
      hash = {
        :name => item.css("h4.student-name").text,
        :location => item.css("p.student-location").text,
        :profile_url => item.css("a").attr("href").text
      }
      hash_array << hash
    end
    hash_array
  end


  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    student_page = Nokogiri::HTML(html)

    student_hash = {}

    student_page.css("div.main-wrapper").each do |page|  #selects main page

      student_page.css(".social-icon-container a").each do |item|  # selects first in-common element
        if item.attr("href").include?("twitter")
          student_hash[:twitter] = item.attr("href")
        elsif item.attr("href").include?("linkedin")
          student_hash[:linkedin] = item.attr("href")
        elsif item.attr("href").include?("github")
          student_hash[:github] = item.attr("href")
        elsif item.attr("href").include?("http://")
          student_hash[:blog] = item.attr("href")
        end

        # checks for profile quote
        if student_page.css(".vitals-text-container").css(".profile-quote")[0].attr("class") == "profile-quote"
          student_hash[:profile_quote] = student_page.css(".vitals-text-container").css(".profile-quote").text
        end
        
        #checks for profile bio
        if student_page.css(".details-container").css(".description-holder p")
          student_hash[:bio] = student_page.css(".details-container").css(".description-holder p").text
        end
      
      end

    end
      # returning the completed hash
      student_hash

  end

end

