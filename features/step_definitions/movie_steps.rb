# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#  flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
   assert page.body.index(e1) < page.body.index(e2) , "Wrong order"
#  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    rating_list.split(",").each do |field|
    field = "ratings_" + field.rstrip.lstrip
    if uncheck then 
      uncheck(field)
    else
      check(field)
    end
  end
end 
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

When /I uncheck all ratings/ do 
    Movie.all_ratings.each do |field|
      uncheck("ratings_" + field.lstrip.rstrip)
  end
end

When /I check all ratings/ do 
    Movie.all_ratings.each do |field|
      check("ratings_" + field.lstrip.rstrip)
  end
end

When /^I press '(.*)'$/ do |pressed|
        click_button(pressed)
end


Then /I should see (none|all) of the movies/ do |filter|
  db_size = 0
  db_size = Movie.all.size if filter == "all"
end

Then /I should (not )?see movies rated: (.*)/ do |negation, rating_list|
  # ensure elements are (not)? visible by comparing
  # number of movies in the database, with the one shown
  # Then I should see PG,R movies
  ratings = rating_list.split(",")
  ratings = Movie.all_ratings - ratings if negation
  db_size = filtered_movies = Movie.find(:all, :conditions => {:rating => ratings}).size
   page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
end


