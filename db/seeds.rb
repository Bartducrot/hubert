# require 'nokogiri'
# require 'open-uri'

# def transform_time(t)
#   match_data = t.match(/((?<h>\d{0,2}) hours? and (?<m>\d{1,2}) mins)|((?<j>\d{0,2}) hours?)|((?<n>\d{1,2}) mins)/)
#   match_data[:h].to_i * 60 + match_data[:m].to_i + match_data[:j].to_i * 60 + match_data[:n].to_i
# end

# Recipe.destroy_all


# 1.times do |i|
#     ingredients = ["italian"]
#     base_url = "https://www.bbcgoodfood.com"
#     ingredients.each do |ingredient|
#       url = "https://www.bbcgoodfood.com/search/recipes?query=#{ingredient}#query=#{ingredient}&page=#{i}"

#       html = Nokogiri::HTML(open(url))

#       html.search('.node-recipe').each do |node|
#         name = node.search('h3 a').text.strip
#         recipe_type = node.search('.field-items > .field-item').text.strip
#         category = node.search('.teaser-item__info-item--skill-level').text.strip

#         show = base_url + node.search('a').attr('href').text.strip
#         show_html = Nokogiri::HTML(open(show))
#         instructions = show_html.search('.method__list p').text.strip

#         recipe = Recipe.new()
#         recipe.name = name
#         recipe.recipe_type = recipe_type
#         recipe.category = category
#         recipe.instructions = instructions
#         recipe.save!


#         puts "hacked recipe #{recipe.name}"

#       end
#     end
# end

# seed ingredients
require 'date'

puts "Start seeding ingredients"
INGREDIENTS = {
  "vegetable" => ["garlic", "onion", "olive", "tomato", "potato", "salad greens",
    "carrot", "basil", "parsley", "rosemary", "bell pepper", "chili pepper", "corn",
    "ginger", "mushroom", "broccoli", "spinach", "green beans", "celery", "red onion",
    "cilantro", "cucumber", "pickle", "dill", "avocado", "sweet potato", "zucchini",
    "shallot", "cabbage", "asparagus", "cauliflower", "mint", "pumpkin", "kale", "scallion",
    "squash", "sun dried tomato", "horseradish", "sweet corn", "beet"],
  "dairy" => ["butter", "eggs", "milk", "parmesan", "cheddar", "cream", "sour cream", "cream cheese",
    "mozzarella", "american cheese", "yogurt", "evaporated milk", "condensed milk", "whipped cream",
    "half and half""monterey jack cheese", "feta", "cottage cheese", "ice cream", "goat cheese",
    "frosting", "swiss cheese", "buttermilk", "velveeta", "ricotta", "powdered milk", "blue cheese",
    "provolone", "colby cheese", "gouda", "pepper jack", "italian cheese", "soft cheese", "romano",
    "brie", "pepperjack cheese", "custard", "cheese soup", "pizza cheese", "ghee", "pecorino cheese",
    "gruyere", "creme fraiche", "neufchatel", "muenster", "asiago", "queso fresco cheese", "hard cheese",
     "havarti cheese", "mascarpone"],
  "meat" => ["chicken breast", "ground beef", "bacon", "sausage", "cooked chicken",
   "ham", "veal", "beef steak", "hot dog", "pork chops", "chicken thighs",
   "ground turkey", "pork", "turkey", "pepperoni", "whole chicken", "chicken leg",
    "ground pork", "chicken wings", "chorizo", "polish sausage", "salami", "pork roast",
    "ground chicken", "pork ribs", "venison", "spam", "lamb", "pork shoulder",
    "beef roast", "bratwurst", "prosciutto", "chicken roast", "bologna", "corned beef",
    "lamb chops", "ground lamb", "beef ribs", "duck", "pancetta", "beef liver",
    "leg of lamb", "chicken giblets", "beef shank", "pork belly", "cornish hen",
    "lamb shoulder", "lamb shank"],
  "sauce" => ["mustard"]
}

UserRecipe.destroy_all
RecipeIngredient.destroy_all
Recipe.destroy_all
Ingredient.destroy_all


INGREDIENTS.each_key do |cat|
  INGREDIENTS[cat].each do |item|
    puts "#{cat} - #{item}"
    ingredient = Ingredient.new()
    ingredient.name = item
    ingredient.category = cat
    ingredient.unit = ["grams", "tbs"].sample
    ingredient.start_of_seasonality = Date.new(2017,1,1)
    ingredient.end_of_seasonality = Date.new(2017,12,31)
    ingredient.save!
  end
end
puts ""
puts "======================================================"
puts ""
puts "create #{Ingredient.all.count} ingredients"
puts ""
puts "Start seeding Recipe with RANDOM name, category, and recipe_type"

PLACES = ["paris", "london", "berlin", "new york", "lyon", "sydney", "milano", "roma", "lille", "bangkok", "ho chi minh city", "hanoi", "los angeles", "tokyo", "america"," california", "asia",  "japan", "france"]
TYPE = ["starter", "main", "dessert", "tapas"]
CATEGORY = ["very easy", "easy", "medium" , "hard", "very hard", "nightmare"]

30.times do
  recipe = Recipe.new()
  main_ingredient = Ingredient.all.sample
  side_ingredient = Ingredient.all.sample
  recipe.name = "#{main_ingredient.name} with #{side_ingredient.name} from #{PLACES.sample}"
  recipe.recipe_type = TYPE.sample
  recipe.category = CATEGORY.sample
  recipe.instructions = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pellentesque dolor ac dolor tempus, eget pellentesque sapien egestas. Maecenas iaculis, neque nec egestas vestibulum, mauris nibh vehicula tellus, et rhoncus tellus enim vel diam. Mauris quis cursus ante. Nulla semper, arcu vitae tempus luctus, elit magna efficitur ligula, vel tincidunt urna augue a velit. Vivamus accumsan massa nec quam hendrerit finibus. Vivamus eros lectus, congue condimentum varius at, varius sed lorem. Suspendisse vitae sem fringilla, mattis dolor at, commodo nisi. Maecenas nulla ex, laoreet sit amet placerat eget, consectetur a purus. Nam sit amet enim sollicitudin, porttitor elit eu, scelerisque felis."
  recipe.save!

  puts "#{recipe.name} id made of:"
  (2..10).to_a.sample.times do
    recipe_ingredient = RecipeIngredient.new()
    recipe_ingredient.ingredient = Ingredient.all.sample
    recipe_ingredient.recipe = recipe
    recipe_ingredient.quantity = (1..10).to_a.sample * 25
    recipe_ingredient.save!
    puts "- #{recipe_ingredient.ingredient.name} #{recipe_ingredient.quantity} #{recipe_ingredient.ingredient.unit}"
  end
  puts "and of course...."

  recipe_ingredient = RecipeIngredient.new()
  recipe_ingredient.ingredient = main_ingredient
  recipe_ingredient.recipe = recipe
  recipe_ingredient.quantity = 250
  recipe_ingredient.save!
  puts "#{recipe_ingredient.ingredient.name} #{recipe_ingredient.quantity} #{recipe_ingredient.ingredient.unit}"
  puts "and"
  recipe_ingredient = RecipeIngredient.new()
  recipe_ingredient.ingredient = side_ingredient
  recipe_ingredient.recipe = recipe
  recipe_ingredient.quantity = 250
  recipe_ingredient.save!
  puts "#{recipe_ingredient.ingredient.name} #{recipe_ingredient.quantity} #{recipe_ingredient.ingredient.unit}"

  puts "#{recipe.name} recipe has been created!"
end

