require 'nokogiri'
require 'open-uri'

RecipeIngredient.destroy_all
Recipe.destroy_all
Ingredient.destroy_all


1.times do |i|
    base_url = "http://allrecipes.com/recipe/"
    index_start = 6663

    url = base_url + "#{index_start + i}"
    puts url

    html = Nokogiri::HTML(open(url))
    recipe_name = ""
    html.search('.summary-background').each do |div|
      recipe_name = div.search('h1.recipe-summary__h1').text.strip
    end

    recipe_type = html.search('.span.toggle-similar__title').text.strip

    category = ["lunch", "breakfast", "dinner", "aperitivo"].sample

    instructions = html.search('directions--section__steps').text.strip

    recipe = Recipe.new()
    recipe.name = recipe_name
    recipe.recipe_type = recipe_type
    recipe.category = category
    recipe.instructions = instructions
    recipe.save!

    #search for the ingredient
    html.search('span.recipe-ingred_txt.added').each do |ingr|

      if ingr.text.strip != "Add all ingredients to list"

        ingredient_category = ["vegetable", "meat", "dairy"].sample
        dose = Ingreedy.parse(ingr.text.strip)
        ingredient_name = dose.ingredient
        ingredient_unit = dose.unit
        ingredient_start_season = Date.new(2017,1,1)
        ingredient_end_season = Date.new(2017,12,31)

        ingredient = Ingredient.new()

        ingredient.name = ingredient_name
        ingredient.category = ingredient_category
        if ingredient_unit.is_a? NilClass
          ingredient.unit = "unit"
        else
          ingredient.unit = ingredient_unit
        end
        ingredient.start_of_seasonality = ingredient_start_season
        ingredient.end_of_seasonality = ingredient_end_season

        ingredient.save!
        puts "#{ingredient.name} ---- #{dose.amount}\'#{ingredient.unit}\'"
      end

    end




    puts "new recipe: #{recipe.name}"


end
