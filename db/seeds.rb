require 'nokogiri'
require 'open-uri'

RecipeIngredient.destroy_all
Recipe.destroy_all
Ingredient.destroy_all


10.times do |i|
    base_url = "http://allrecipes.com/recipe/"
    # index_start = 6663
    index_start = 7663

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

    puts "new recipe: #{recipe.name}"
    puts "#{recipe.instructions}"
    puts 'Ingredient :'

    #search for the ingredient
    html.search('span.recipe-ingred_txt.added').each do |ingr|
      puts "---- #{ingr.text.strip}"

      if ingr.text.strip != "Add all ingredients to list"
        dose = Ingreedy.parse(ingr.text.strip)
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
      puts "the association between #{recipe.name} and #{ingredient.name} has been created"
      end
    end




    puts "new recipe: #{recipe.name}"


end
