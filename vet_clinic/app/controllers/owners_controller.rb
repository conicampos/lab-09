class OwnersController < ApplicationController
  before_action :set_owner, only: [:show, :edit, :update, :destroy]

  def index
    @owners = policy_scope(Owner).includes(:pets)
  end

  def show
    authorize @owner
  end

  def new
    @owner = Owner.new
    authorize @owner
  end

  def edit
    authorize @owner
  end

  def create
    @owner = Owner.new
    @owner.assign_attributes(owner_params)
    authorize @owner
    if @owner.save
      redirect_to @owner, notice: 'Owner was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @owner
    if @owner.update(owner_params)
      redirect_to @owner, notice: 'Owner was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @owner
    @owner.destroy
    redirect_to owners_url, notice: 'Owner was successfully destroyed.', status: :see_other
  end

  private
    def set_owner
      @owner = Owner.find(params[:id])
    end

    def owner_params
      params.require(:owner).permit(policy(@owner).permitted_attributes)
    end
end
