class InterestsController < ApplicationController
  include TagActions
  before_action :authenticate_user!, except: [:index]
  before_action :set_interest, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if params[:tagged]
      @interests = Interest.tagged_with(params[:tagged]).paginate(page: params[:page], per_page: 8)
    else
      @interests = Interest.paginate(page: params[:page], per_page: 8)
    end
    @tags = Interest.tag_counts_on(:tags).to_a.sort_by(&:name)
  end

  def new
    @interest = Interest.new
    respond_with(@interest)
  end

  def create
    @interest = Interest.new(interest_params)
    @interest.save
    redirect_to :interests
  end

  def destroy
    @interest.destroy
    redirect_to :interests
  end

  private

  def set_interest
    @interest = Interest.find(params[:id])
  end

  def interest_params
    params.require(:interest).permit(:url, :tag_list)
  end
end
