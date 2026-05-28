class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  def index
    @pets = policy_scope(Pet).includes(:owner)
  end

  def show
    authorize @pet
  end

  def new
    @pet = Pet.new(owner: current_user.owner)
    authorize @pet
  end

  def edit
    authorize @pet
  end

  def create
    @pet = Pet.new(owner: current_user.owner)
    @pet.assign_attributes(pet_params)
    @pet.owner = current_user.owner if current_user.owner?
    authorize @pet
    if @pet.save
      redirect_to @pet, notice: 'Pet was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @pet
    if @pet.update(pet_params)
      redirect_to @pet, notice: 'Pet was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @pet
    @pet.destroy
    redirect_to pets_url, notice: 'Pet was successfully destroyed.', status: :see_other
  end

  private
    def set_pet
      @pet = Pet.find(params[:id])
    end

    def pet_params
      params.require(:pet).permit(policy(@pet).permitted_attributes)
    end
end
