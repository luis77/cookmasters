class WelcomeController < ApplicationController
  def index
    @las_mejores_recetas = Recipe.Recetas_con_mas_likes.limit(3)
    @recetas = Recipe.all.page(params[:page]).per(3)
  end
end
