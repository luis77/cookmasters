module Api
	module V1
		class RecipesController < ApplicationController
			def index
				recipes = Recipe.order('created_at DESC');
				render json: {status: 'SUCCESS', message:'Loaded recipes', data:recipes},status: :ok
			end
			
			def show
				recipe = Recipe.find(params[:id]);
				render json: {status: 'SUCCESS', message:'Loaded recipe', data:recipe},status: :ok
			end
			
			def create
				recipe = Recipe.new(recipe_params);

				if recipe.save
					render json: {status: 'SUCCESS', message:'Saved recipe', data:recipe},status: :ok
				else
					render json: {status: 'ERROR', message:'Recipe not saved', data:recipe.errors},status: :unprocessable_entity
				end
			end

			def destroy
				recipe = Recipe.find(params[:id]);
				recipe.destroy
				render json: {status: 'SUCCESS', message:'Deleted recipe', data:recipe},status: :ok
			end

			def update
				recipe = Recipe.find(params[:id]);
				if recipe.update_attributes(recipe_params)
					render json: {status: 'SUCCESS', message:'Updated recipe', data:recipe},status: :ok
				else
					render json: {status: 'ERROR', message:'Recipe not updated', data:recipe.errors},status: :unprocessable_entity
				end
			end

			def like
				@like = Like.find_by(recipe_id: params[:receta], user_id: params[:usuario]);
				if @like.nil?
			      me_gusta = Like.create(recipe_id: params[:receta], user_id: params[:usuario]) 
					render json: {status: 'SUCCESS', message:'Recipe Liked', data:me_gusta},status: :ok
			    else
			      @like.delete 
					render json: {status: 'SUCCESS', message:'Recipe erased', data:@like},status: :ok
			    end
			end



			private

			def recipe_params
				params.permit(:name, :body)	
			end
		end
	end
end