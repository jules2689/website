class InterestsController < ApplicationController
  include TagActions
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user_from_token!, only: [:tags, :create]
  before_action :authenticate_user!, except: [:index]
  before_action :set_interest, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    if params[:tagged]
      @interests = Interest.is_public.tagged_with(params[:tagged]).paginate(page: params[:page], per_page: 8)
    else
      @interests = Interest.is_public.paginate(page: params[:page], per_page: 8)
    end
    @tags = Interest.tag_counts_on(:tags).to_a.sort_by(&:name)
    respond_with(@interests)
  end

  def new
    @interest = Interest.new
    respond_with(@interest)
  end

  def create
    @interest = Interest.new(interest_params)
    @interest.save
    respond_with(@interest)
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
    params.require(:interest).permit(:url, :tag_list, :is_private)
  end
end
