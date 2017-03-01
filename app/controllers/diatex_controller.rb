class DiatexController < ApplicationController
  http_basic_authenticate_with name: "diatex", password: Rails.application.secrets.diatex_password
  include Latex

  def latex
    if params[:tex].blank?
      render json: { error: 'tex param was not found' }, status: 422
      return
    end

    uid = Digest::MD5.hexdigest(params[:tex])

    success, dvi_path = convert_to_dvi(uid, params)
    unless success
      render json: { error: 'latex command did not succeed', input: params[:tex], output: dvi_path }, status: 500
      return
    end

    success, png_path = convert_to_png(uid, dvi_path)
    unless success
      render json: { error: 'dvipng command did not succeed', input: params[:tex], output: png_path }, status: 500
      return
    end

    send_file png_path, type: 'image/png', disposition: 'inline'
  end
end
