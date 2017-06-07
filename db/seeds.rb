require 'nokogiri'
require 'open-uri'

def transform_time(t)
  match_data = t.match(/((?<h>\d{0,2}) hours? and (?<m>\d{1,2}) mins)|((?<j>\d{0,2}) hours?)|((?<n>\d{1,2}) mins)/)
  match_data[:h].to_i * 60 + match_data[:m].to_i + match_data[:j].to_i * 60 + match_data[:n].to_i
end

Recipe.destroy_all


1.times do |i|
    ingredients = ["italian"]
    base_url = "https://www.bbcgoodfood.com"
    ingredients.each do |ingredient|
      url = "https://www.bbcgoodfood.com/search/recipes?query=#{ingredient}#query=#{ingredient}&page=#{i}"

      html = Nokogiri::HTML(open(url))

      html.search('.node-recipe').each do |node|
        name = node.search('h3 a').text.strip
        recipe_type = node.search('.field-items > .field-item').text.strip
        category = node.search('.teaser-item__info-item--skill-level').text.strip

        show = base_url + node.search('a').attr('href').text.strip
        show_html = Nokogiri::HTML(open(show))
        instructions = show_html.search('.method__list p').text.strip

        recipe = Recipe.new()
        recipe.name = name
        recipe.recipe_type = recipe_type
        recipe.category = category
        recipe.instructions = instructions
        recipe.save!


        puts "hacked recipe #{recipe.name}"

      end
    end
end



