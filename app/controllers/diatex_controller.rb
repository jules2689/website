class DiatexController < ApplicationController
  http_basic_authenticate_with name: "diatex", password: Rails.application.secrets.diatex_password
  include Latex

  def latex
    if params[:tex].blank?
      render json: { error: 'tex param was not found' }, status: 422
      return
    end

    uid = Digest::MD5.hexdigest(params[:tex])
    image_maker = ImageMaker.new
    remote_path = "images/latex/#{uid}.png"

    # Check for Cache
    if image_maker.exists?(remote_path)
      Rails.logger.info "Already made, sending cache"
      render json: { url: image_maker.url(remote_path) }
      return
    end

    # Convert latex to DVI
    success, dvi_path = convert_to_dvi(uid, params)
    unless success
      render json: { error: 'latex command did not succeed', input: params[:tex], output: dvi_path }, status: 500
      return
    end

    # Convert DVI to PNG
    success, png_path = convert_to_png(uid, dvi_path)
    unless success
      render json: { error: 'dvipng command did not succeed', input: params[:tex], output: png_path }, status: 500
      return
    end

    # Send response
    json_hash = ImageMaker.new.create_image("#{uid}.png", remote_path, png_path.to_s)
    render json: { url: json_hash[:url] }
  end
end
