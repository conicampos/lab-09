class VetsController < ApplicationController
  before_action :set_vet, only: [:show, :edit, :update, :destroy]

  def index
    @vets = Vet.all
  end

  def show
  end

  def new
    @vet = Vet.new
  end

  def edit
  end

  def create
    @vet = Vet.new(vet_params)
    if @vet.save
      redirect_to @vet, notice: 'Vet was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @vet.update(vet_params)
      redirect_to @vet, notice: 'Vet was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vet.destroy
    redirect_to vets_url, notice: 'Vet was successfully destroyed.', status: :see_other
  end

  private
    def set_vet
      @vet = Vet.find(params[:id])
    end

    def vet_params
      params.require(:vet).permit(:first_name, :last_name, :email, :specialization)
    end
end