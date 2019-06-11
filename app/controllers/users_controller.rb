class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!
  before_action :clear_search_index, :only => [:index]



  def user_check
    @usuariox = User.comprobar_existencia(params[:user][:username]).first
    respond_to do |format|
    format.json { render :json => !@usuariox }
    end
  end

  def user_check2
    @usuario_Ex = User.comprobar_existencia_Email(params[:user][:email]).first
    respond_to do |format|
    format.json { render :json => !@usuario_Ex }
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation, :Nombre, :Supervisor, :cover)
    end

end
