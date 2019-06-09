class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :recipe_like]
  before_action :authenticate_user!

  # GET /recipes
  # GET /recipes.json
  def index
    @recipe = Recipe.new
    @recipes = Recipe.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
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
    respond_to do |format|
      if @me_gusta.present?
        format.js {flash.now[:notice] = 'Te ha gustado la receta'} 
      else 
        format.js {} 
      end
    end
  end


  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = current_user.recipes.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        if params[:lista].present?
          params[:lista].each do |(c,ingrediente)|
            Ingredient.create(name: ingrediente, recipe_id:@recipe.id)
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
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
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
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :body, :foto)
    end
end
