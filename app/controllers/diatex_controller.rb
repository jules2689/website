class DiatexController < ApplicationController
  http_basic_authenticate_with name: "diatex", password: Rails.application.secrets.diatex_password
  include Latex
  include SequenceDiagram

  def latex
    uid, remote_path = image_request(:latex)
    return if uid.nil?
    exp = Calculus::Expression.new(params[:latex])

    json_hash = ImageMaker.new.create_image("#{uid}.png", remote_path, exp.to_png)
    render json: { input: params[:latex], url: json_hash[:url] }
  rescue Calculus::ParserError => e
    render json: { error: e.message }, status: 422
  end

  def diagram
    uid, remote_path = image_request(:diagram)
    return if uid.nil?
    success, png_path = convert_mermaid_to_png(params[:diagram])

    unless success
      render json: { error: 'mermaid command did not succeed', input: params[:diagram], output: png_path }, status: 500
    end

    # Send response
    json_hash = ImageMaker.new.create_image("#{uid}.png", remote_path, path.to_s)
    render json: { input: params[:diagram], url: json_hash[:url] }
  end

  private

  def image_request(param_name)
    if params[param_name].blank?
      render json: { error: "#{param_name} param was not found" }, status: 422
      return nil
    end

    uid = Digest::MD5.hexdigest(params[param_name])
    image_maker = ImageMaker.new
    remote_path = "images/#{param_name}/#{uid}.png"

    # Check for Cache
    if image_maker.exists?(remote_path)
      Rails.logger.info "Already made, sending cache"
      render json: { input: params[param_name], url: image_maker.url(remote_path) }
      return nil
    end

    [uid, remote_path]
  end
end
