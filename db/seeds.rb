require 'nokogiri'
require 'open-uri'
require 'date'

# puts "Start seeding ingredients"
# INGREDIENTS = {
#   "vegetable" => ["garlic", "onion", "olive", "tomato", "potato", "salad greens",
#     "carrot", "basil", "parsley", "rosemary", "bell pepper", "chili pepper", "corn",
#     "ginger", "mushroom", "broccoli", "spinach", "green beans", "celery", "red onion",
#     "cilantro", "cucumber", "pickle", "dill", "avocado", "sweet potato", "zucchini",
#     "shallot", "cabbage", "asparagus", "cauliflower", "mint", "pumpkin", "kale", "scallion",
#     "squash", "sun dried tomato", "horseradish", "sweet corn", "beet"],
#   "dairy" => ["butter", "eggs", "milk", "parmesan", "cheddar", "cream", "sour cream", "cream cheese",
#     "mozzarella", "american cheese", "yogurt", "evaporated milk", "condensed milk", "whipped cream",
#     "half and half""monterey jack cheese", "feta", "cottage cheese", "ice cream", "goat cheese",
#     "frosting", "swiss cheese", "buttermilk", "velveeta", "ricotta", "powdered milk", "blue cheese",
#     "provolone", "colby cheese", "gouda", "pepper jack", "italian cheese", "soft cheese", "romano",
#     "brie", "pepperjack cheese", "custard", "cheese soup", "pizza cheese", "ghee", "pecorino cheese",
#     "gruyere", "creme fraiche", "neufchatel", "muenster", "asiago", "queso fresco cheese", "hard cheese",
#      "havarti cheese", "mascarpone"],
#   "meat" => ["chicken breast", "ground beef", "bacon", "sausage", "cooked chicken",
#    "ham", "veal", "beef steak", "hot dog", "pork chops", "chicken thighs",
#    "ground turkey", "pork", "turkey", "pepperoni", "whole chicken", "chicken leg",
#     "ground pork", "chicken wings", "chorizo", "polish sausage", "salami", "pork roast",
#     "ground chicken", "pork ribs", "venison", "spam", "lamb", "pork shoulder",
#     "beef roast", "bratwurst", "prosciutto", "chicken roast", "bologna", "corned beef",
#     "lamb chops", "ground lamb", "beef ribs", "duck", "pancetta", "beef liver",
#     "leg of lamb", "chicken giblets", "beef shank", "pork belly", "cornish hen",
#     "lamb shoulder", "lamb shank"],
#   "sauce" => ["mustard", "ketchup"]
# }



ShoppingItem.destroy_all
UserRecipe.destroy_all
# RecipeIngredient.destroy_all
# Recipe.destroy_all
# Ingredient.destroy_all


100.times do |i|
    base_url = "http://allrecipes.com/recipe/"
    # index_start = 6663
    index_start = 15020

    url = base_url + "#{index_start + i}"
    puts url

    html = Nokogiri::HTML(open(url))
    recipe_name = ""
    html.search('.summary-background').each do |div|
      recipe_name = div.search('h1.recipe-summary__h1').text.strip
    end

    recipe_type = html.search('.breadcrumbs li:nth-child(3) a span').text.strip

    category = ["lunch", "breakfast", "dinner", "aperitivo"].sample

    instructions = ""
    html.search('.directions--section__steps span').each do |step|
      instructions += step.text.strip
    end
    # instructions = html.search('.directions--section__steps ').text.strip

    recipe = Recipe.new()
    recipe.name = recipe_name
    recipe.recipe_type = recipe_type
    recipe.category = category
    recipe.instructions = instructions
    recipe.save!

    puts "new recipe: #{recipe.name}"
    puts "Type:"
    puts "#{recipe.recipe_type}"
    puts "Instructions: "
    puts "#{recipe.instructions}"
    puts 'Ingredient :'

    #search for the ingredient
    html.search('span.recipe-ingred_txt.added').each do |ingr|
      puts "---- #{ingr.text.strip}"

      if ingr.text.strip != "Add all ingredients to list"
        begin
          dose = Ingreedy.parse(ingr.text.strip)
        rescue Exception => e
        end
        if dose
          ingredient_category = ["vegetable", "meat", "dairy"].sample
          ingredient = Ingredient.find_by_name(dose.ingredient)

          if ingredient
            puts "#{ingredient.name} already exist"
          else
            ingredient = Ingredient.new()
            ingredient_name = dose.ingredient
            ingredient_unit = dose.unit
            ingredient_start_season = Date.new(2017,1,1)
            ingredient_end_season = Date.new(2017,12,31)

            ingredient = Ingredient.new()

            ingredient.name = ingredient_name
            ingredient.category = ingredient_category
            ingredient.start_of_seasonality = ingredient_start_season
            ingredient.end_of_seasonality = ingredient_end_season
            if ingredient_unit.is_a? NilClass
              ingredient.unit = "unit"
            else
              ingredient.unit = ingredient_unit
            end

            ingredient.save!

            puts "#{ingredient.name} ---- \'#{ingredient.unit}\' has been created"
          end

          association = RecipeIngredient.new()
          association.recipe = recipe
          association.ingredient = ingredient
          association.quantity = dose.amount.to_i
          association.save!
          puts "the association between #{recipe.name} and #{ingredient.name} has been created (#{association.quantity} )"
        end
      else
        puts "#{ingr.text.strip} --- NOT AN INGREDIENT!"
      end
    end




    puts "new recipe: #{recipe.name}"


end
