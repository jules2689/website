class FrontPageWidgetsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_front_page_widget, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @front_page_widgets = FrontPageWidget.all
    respond_with(@front_page_widgets)
  end

  def positions
    @front_page_widgets = FrontPageWidget.all
    respond_with(@front_page_widgets)
  end

  def save_positions
    params["positions"].each do |position|
      data = position.split(",")
      widget = FrontPageWidget.find(data.first)
      widget.position = data.last
      widget.save
    end
    redirect_to root_url
  end

  def new
    @front_page_widget = FrontPageWidget.new
    respond_with(@front_page_widget)
  end

  def edit
  end

  def create
    @front_page_widget = FrontPageWidget.new(front_page_widget_params)
    max = FrontPageWidget.maximum(:position) || 0
    @front_page_widget.position = max + 1
    @front_page_widget.save
    redirect_to root_url
  end

  def update
    @front_page_widget.update(front_page_widget_params)
    redirect_to root_url
  end

  def destroy
    @front_page_widget.destroy
    redirect_to root_url
  end

  private

  def set_front_page_widget
    @front_page_widget = FrontPageWidget.find(params[:id])
  end

  def front_page_widget_params
    params.require(:front_page_widget).permit(:title, :subtext, :image, :url)
  end
end
