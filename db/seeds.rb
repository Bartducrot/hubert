require 'nokogiri'
require 'open-uri'
require 'date'
# require 'watir'
# require 'selenium-webdriver'
# require 'selenium'

# ATTEMPT TO USE TOR TO SCRAPE ON WEBSITE WITHOUT RESTRICTION
# browser = Watir::Browser.new :phantomjs
#   profile = Selenium::WebDriver::PhantomJS::Profile.new
#   profile['network.proxy.socks'] = "127.0.0.1"
#   profile['network.proxy.socks_port'] = 9050
#   profile['network.proxy.type'] = 1
#   browser = Watir::Browser.new :phantomjs, :profile => profile

#   puts "hello there!"
#   browser.goto "www.hubert-cooks.com"
#   # p browser.public_methods.sort
#   browser.goto("http://www.whatsmyip.org/")
#   ip = browser.span(:id, "ip").text
#   puts ip
#   browser.goto "http://allrecipes.com/recipe/15000"
#   title_allrecipe = browser.title
#   puts title_allrecipe
# browser.close


# Clear the database
ShoppingItem.destroy_all
UserRecipe.destroy_all
RecipeIngredient.destroy_all
IngredientTaste.destroy_all
Recipe.destroy_all
Ingredient.destroy_all


# List of ingredient categories
CATEGORIES = ["dairy", "vegetable", "alcohol", "condiments", "meat", "baking",
  "seasonings", "spices", "fish", "sauces", "sweeteners", "alternatives",
  "oils", "fruits", "beverages", "nuts", "desserts", "seafood", "soup"]

100.times do |i|

    base_url = "https://allrecipes.com/recipe/"
    # index_start = 6663
    index_start = 16730

    url = base_url + "#{index_start + i}/"
    puts url
    begin
      html = Nokogiri::HTML(open(url))
      recipe_name = ""
      html.search('.summary-background').each do |div|
        recipe_name = div.search('h1.recipe-summary__h1').text.strip
      end

      recipe_type = html.search('.breadcrumbs li:nth-child(3) a span').text.strip

      category = ["lunch", "breakfast", "dinner", "aperitivo"].sample

      instructions = ""
      html.search('.directions--section__steps span').each do |step|
        instructions += "#{step.text.strip}\n"
      end

      photo_url = html.search('.rec-photo').first.attribute('src')

      recipe = Recipe.find_by_name(recipe_name)
      if recipe
        puts "this recipe already exist in the data base : name = \"#{recipe.name}\" , id = #{recipe.id}"
      else

        recipe = Recipe.new()
        recipe.name = recipe_name
        recipe.recipe_type = recipe_type
        recipe.category = category
        puts "instructions before regex"
        puts instructions
        puts "===================="
        instructions = instructions.match(/\A\d+/).nil? ? instructions : instructions[(instructions.match(/\A\d+/)[0].length - 1)..-1]
        puts "instructions after regex"
        puts instructions
        recipe.instructions = instructions
        recipe.remote_photo_url = photo_url
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
            # Ingreedy allow to extract from a string an ingredient name, unit and quantity
            begin
              dose = Ingreedy.parse(ingr.text.strip)
            rescue Exception => e
              puts 'error with Ingreedy'
            end
            puts "ingredient in the recipe"

            if dose
              ingredient_name = dose.ingredient
              # As we don't know the category, we put a random one (the real category has to be modified by hand)
              ingredient_category = CATEGORIES.sample
              # Process the ingredient name
              # DELETE THE S at the end excet for double s words
              if ingredient_name.match(/s{2}/)
                ingredient_unit = dose.ingredient
              else
                ingredient_name = dose.ingredient.gsub(/s$/, "")
              end
              t = ingredient_name
              t = t.match(/([\w ]+),([\w ]+)/).nil? ? t : t.match(/([\w ]+),([\w ]+)/)[1]
              ingredient_name = t.gsub(/\([\w ]+\)/, "").strip.gsub(/  /, " ")

              # check if the Ingredient already exist
              ingredient = Ingredient.find_by_name(ingredient_name)
              if ingredient
                puts "#{ingredient.name} already exist"
              else
                # if the Ingredient doesn't exist, we create it
                ingredient = Ingredient.new()
                ingredient.name = ingredient_name
                ingredient.category = ingredient_category
                # AS WE DON'T KNOW THE SEASONLITY OF THE INGREDIENT, WE JUST PUT THE WHOLE YEAR
                ingredient.start_of_seasonality = Date.new(2017,1,1)
                ingredient.end_of_seasonality = Date.new(2017,12,31)
                ingredient.save!
                puts "#{ingredient.name} ---- \'#{ingredient.category}\' has been created"
              end

              # Creation of the link between Recipe and Ingredient (RecipeIngredient)
              association = RecipeIngredient.new()
              association.recipe = recipe
              association.ingredient = ingredient
              ingredient_quantity = dose.amount
              if ingredient_quantity.is_a? NilClass
                association.quantity = 1.0
              else
                association.quantity = ingredient_quantity
              end
              ingredient_unit = dose.unit
              if ingredient_unit.is_a? NilClass
                association.unit = "unit"
              else
                association.unit = ingredient_unit
              end
              association.save!
              puts "the dose has been created (#{ingredient.name} - #{association.quantity} #{association.unit} )"
            end
          else
            # if Ingreedy doesn't have any answer, we just assume that the Ingredient is not an Ingredient
            puts "#{ingr.text.strip} --- NOT AN INGREDIENT!"
          end
        end
      end




      puts "new recipe: #{recipe.name} - #{recipe.recipe_type} - #{recipe.category}"


      puts "Enought waiting I hope"
    rescue Exception => e
      puts e
      puts 'error somewhere, has to wait'
    end

    waiting_time = (1..5).to_a.sample
    puts "waiting #{waiting_time}second in order to avoid : \'OpenURI::HTTPError: 429 Too Many Requests\'......"

    waiting_time.times do |sec|
      puts "#{sec + 1} second(s)"
      sleep(1)
    end

end

# AS UNIT IS IN THE RecipeIngredient Table, this is no longer needed
# ingredient_unit = dose.unit
# if ingredient_unit.is_a? NilClass
#   ingredient.unit = "unit"
# else
#   ingredient.unit = ingredient_unit
# end

# stuff to do with dose.amount (convertion to the right unit )
# unless dose.unit == ingredient.unit
# # TODO convert the quantity to the right amount
#   if dose.unit == "cup" && ingredient.unit == "tablespoon"
#     ingredient_quantity = dose.amount * 16
#   elsif dose.unit == "cup" && ingredient.unit == "teaspoon"
#     ingredient_quantity = dose.amount * 48
#   elsif dose.unit == "tablespoon" && ingredient.unit == "cup"
#     ingredient_quantity = dose.amount * 0.0625
#   elsif dose.unit == "tablespoon" && ingredient.unit == "teaspoon"
#     ingredient_quantity = dose.amount * 3
#   elsif dose.unit == "teaspoon" && ingredient.unit == "cup"
#     ingredient_quantity = dose.amount * 0.208333
#   elsif dose.unit == "teaspoon" && ingredient.unit == "tablespoon"
#     ingredient_quantity = dose.amount * 0.333333
#   else
#     ingredient_quantity = dose.amount
#   end
# end

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
