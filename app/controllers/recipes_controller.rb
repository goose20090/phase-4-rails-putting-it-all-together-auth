class RecipesController < ApplicationController
    before_action :authorize

    def index
        recipes = Recipe.all
        render json: recipes, include: :user 
    end

    def create
        recipe = Recipe.create(title: params[:title], instructions: params[:instructions], minutes_to_complete: params[:minutes_to_complete], user_id: session[:user_id])
        if recipe.valid?
            render json: recipe, include: :user, status: :created
        else
            render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
        end
    end

    private

    def authorize
        return render json: {errors: ["Not authorised"]}, status: :unauthorized unless session.include? :user_id
    end
end
