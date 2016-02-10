class InterestsController < ApplicationController
  include TagActions
  skip_before_action :verify_authenticity_token, if: proc { |c| c.request.format == 'application/json' }
  before_action :authenticate_user_from_token!, only: [:tags, :create], if: -> { request.format.json? }
  before_action :authenticate_user!, except: [:index]
  before_action :set_interest, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @interests = if params[:private] && user_signed_in?
                   Interest.is_not_public
                 else
                   Interest.is_public
                 end

    filter_interests!(@interests)
    @tags = @interests.tag_counts_on(:tags).to_a.sort_by(&:name)
    respond_with(@interests)
  end

  def new
    @interest = Interest.new
    respond_with(@interest)
  end

  def create
    @interest = Interest.new(interest_params)
    @interest.save
    redirect_to interests_path
  end

  def destroy
    @interest.destroy
    redirect_to :interests
  end

  private

  def filter_interests!(_interests)
    @interests = @interests.tagged_with(params[:tagged]) if params[:tagged]
    @interests = @interests.paginate(page: params[:page], per_page: 12)
  end

  def set_interest
    @interest = Interest.find(params[:id])
  end

  def interest_params
    params.require(:interest).permit(:url, :tag_list, :is_private)
  end
end
