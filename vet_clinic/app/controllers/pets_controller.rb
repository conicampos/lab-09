class PetsController < ApplicationController
  def index
    @pets = Pet.includes(:owner).all
  end

  def show
    @pet = Pet.find(params[:id])
  end
end