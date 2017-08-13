namespace :recipe do


  desc "Make an ingredient appear only one time in the recipe i.e. only one RecipeIngredient per Ingredient for one Recipe, merging the quantity"

  task uniq_ingredient: :environment do
    # Take all the recipe
    # On each recipe do
    Recipe.all.each do |recipe|
      puts "######################################"
      puts "recipe id : #{recipe.id}"
      # check if every ingredient is uniq
      arr = []
      # take all the recipe ingredient of the recipe
      list = recipe.recipe_ingredients
      list.each do |r_ingr|
        # make an array with every ingredient_id ==> ex: arr = [1456, 2785, 3832, 4737, 1456, 4737]
        arr << r_ingr.ingredient_id
      end
      puts "ingredients before algorithm : count = #{recipe.recipe_ingredients.length}"
      p arr
      # create an array with the id of duplicates ingredient
      duplicates = arr.select { |e| arr.count(e) > 1 }.uniq
      # duplicates = [ingredient_id, ....] ==> ex: duplicates = [1456, 4737]
        # list.length.times do |i|
        #   # add the id of the RecipeIngredient in the array
        #   arr[i] = [arr[i], list[i].id]
        # end
        # => arr = [[ingredient_id, recipe_ingredient_id], .....]
        # => ex: arr = [[1456,11] ,[2785,25], [3832,34], [4737,74], [1456,58], [4737, 89]]
      p duplicates
      until duplicates.length == 0
        puts "let's unify this ingredient"
        # take the laste ingredient_id in duplicates as ingr_id
        ingr_id = duplicates.pop
        p "ingredient id: #{ingr_id}"
        res = list.where(ingredient_id: ingr_id)
        puts "---------"
        res.each do |r|
          puts "quantity: #{r.quantity}"
        end
        puts "---------"
        puts "res #{res.first.quantity}"
        # sum all the quantity of the ingredient in a variable (quant)
        quant = 0.0
        p quant
        p res.first.quantity
        puts "==================="
        res.each do |r|
          p r.quantity
          p quant
          quant += r.quantity
        end
        # take the first recurent occurence of the ingredient
        sum = res.first
        # update the first recipe_ingredient quantity with the value of th sum
        sum.quantity = quant
        sum.save
        # delete the recipe_ingredient that appear several times
        puts recipe.recipe_ingredients.where(ingredient_id: ingr_id).length
        until recipe.recipe_ingredients.where(ingredient_id: ingr_id).length == 1
          res.second.destroy
          puts recipe.recipe_ingredients.where(ingredient_id: ingr_id).length
        end
        # res.each do |recipe_ingredient|
        #     res.each do |r|
        #       r.destroy if recipe_ingredient != sum
        #     end
        # end
      end

      puts "ingredients after algorithm : count = #{Recipe.find(recipe.id).recipe_ingredients.length}"


    end
    # (ie there is only one RecipeIngredient for a couple Recipe/Ingredient)
    # until all ingredient are uniq in the recipe

    # If there is at least one ingredient that appear twice in the RecipeIngredient's of the recipe
    # merge two RecipeIngredient with the same Ingredient together in the first occurence (addition of the two quantity), delete the second RecipeIngredient occurence
    # when all the Ingredient are uniq, go to next recipe
  end

end
