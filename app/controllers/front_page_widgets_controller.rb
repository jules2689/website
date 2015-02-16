class FrontPageWidgetsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_front_page_widget, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @front_page_widgets = FrontPageWidget.all
    respond_with(@front_page_widgets)
  end

  def new
    @front_page_widget = FrontPageWidget.new
    respond_with(@front_page_widget)
  end

  def edit
  end

  def create
    @front_page_widget = FrontPageWidget.new(front_page_widget_params)
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
