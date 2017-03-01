class DiatexController < ApplicationController
  http_basic_authenticate_with name: "diatex", password: Rails.application.secrets.diatex_password
  include SequenceDiagram

  def latex
    if params[:latex].blank?
      render json: { error: "latex param was not found" }, status: 422
      return nil
    end

    # Unescape param to handle URL and JSON, though JSON encoding
    # can mess things up, so always escape first
    latex = CGI.unescape(params[:latex])
    uid = Digest::MD5.hexdigest(latex)
    remote_path = "images/latex/#{uid}.png"

    Rails.logger.info "Got latex #{latex}"

    # Check Cache First
    return if image_cache(latex, remote_path)

    # Generate Image & send reponse
    exp = Calculus::Expression.new(latex, parse: false)
    FileUtils.mv(exp.to_png, File.join(TEMP_IMAGES, "#{uid}.png"))

    json_hash = ImageMaker.new.create_image("#{uid}.png", remote_path, exp.to_png)
    render json: { input: params[:latex], url: json_hash[:url] }
  rescue Calculus::ParserError => e
    render json: { error: e.message }, status: 422
  end

  def diagram
    if params[:diagram].blank?
      render json: { error: "diagram param was not found" }, status: 422
      return nil
    end

    uid = Digest::MD5.hexdigest(params[:diagram])
    remote_path = "images/diagram/#{uid}.png"

    # Check Cache First
    return if image_cache(params[:diagram], remote_path)

    # Generate Image
    success, png_path = convert_mermaid_to_png(params[:diagram])
    unless success
      render json: { error: 'mermaid command did not succeed', input: params[:diagram], output: png_path }, status: 500
    end

    # Send response
    json_hash = ImageMaker.new.create_image("#{uid}.png", remote_path, path.to_s)
    render json: { input: params[:diagram], url: json_hash[:url] }
  end

  private

  def check_param(param_name)
    if params[param_name].blank?
      render json: { error: "#{param_name} param was not found" }, status: 422
      return nil
    end
  end

  def image_cache(param, remote_path)
    image_maker = ImageMaker.new

    # Check for Cache
    if image_maker.exists?(remote_path)
      Rails.logger.info "Already made, sending cache"
      render json: { input: param, url: image_maker.url(remote_path) }
      return true
    end

    false
  end
end
