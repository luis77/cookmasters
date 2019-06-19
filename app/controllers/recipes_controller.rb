class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :recipe_like]
  before_action :authenticate_user!

  # GET /recipes
  # GET /recipes.json
  def index
    @recipe = Recipe.new
    @recipes = current_user.recipes.page(params[:page]).per(15)
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @likex = ActiveRecord::Base.connection.execute("SELECT FROM total_likes()")

    @likes = @recipe.likes.all.count
    @me_gusta = Like.find_by(recipe_id: @recipe.id, user_id: current_user.id)
    respond_to do |format|
        format.html
        format.pdf do
          pdf = RecipePdf.new(@recipe)
          send_data pdf.render, filename: "Receta##{@recipe.try(:name)}.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
    end
  end

  def recipe_like
    @like = Like.find_by(recipe_id: @recipe.id, user_id: current_user.id)
    if @like.nil?
      @me_gusta = Like.create(recipe_id: @recipe.id, user_id: current_user.id) 
    else
      @like.delete 
    end


    @likes = @recipe.likes.all.count
    respond_to do |format|
      if @me_gusta.present?
        format.js {flash.now[:notice] = 'Te ha gustado la receta'} 
      else 
        format.js {} 
      end
    end
  end

  def datos_receta
    @recipe_edit = Recipe.find_by(id: params[:recipe])
    @recipe_edit.ingredients.build

    respond_to do |format|
      format.js #para que se puedan enviar los datos de la busqueda del @search de la gema
    end
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
    @recipe.ingredients.build
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = current_user.recipes.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        if params[:lista].present?
          params[:lista].each do |(c,ingrediente)|
            Ingredient.create(name: ingrediente, recipe_id:@recipe.id) if ingrediente != ""
          end
        end
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
        format.js {flash.now[:notice] = 'La receta se ha creado de forma exitosa.'} #ajax
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
        format.js {flash.now[:alert] = 'Error al crear la receta.'} #ajax
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)

        if params[:lista].present?
          params[:lista].each do |(c,ingrediente)|
            Ingredient.create(name: ingrediente, recipe_id:@recipe.id) if ingrediente != ""
          end
        end

        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
        format.js {flash.now[:notice] = 'La receta se ha actualizado de forma exitosa.'} 
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
        format.js {flash.now[:alert] = 'Error al actuar la receta.'} 
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
      format.js {flash.now[:notice] = 'La receta se ha eliminado de forma exitosa.'} #ajax
    end
  end

  def eliminar_ingrediente
    @ingredient = Ingredient.find_by_id(params[:id])
    @ingredient.destroy
    @index = params[:index] #para eliminar el ingrediente del formulario
    respond_to do |format|
      format.js 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :body, :foto, ingredients_attributes: Ingredient.attribute_names.map(&:to_sym).push(:_destroy))
    end
end
