class DiatexController < ApplicationController
  http_basic_authenticate_with name: "diatex", password: Rails.application.secrets.diatex_password
  include Latex
  include SequenceDiagram

  def latex
    image_request(:latex) do |uid|
      # Convert latex to DVI
      success, dvi_path = convert_latex_to_dvi(uid, params)
      unless success
        render json: { error: 'latex command did not succeed', input: params[:latex], output: dvi_path }, status: 500
        return
      end

      # Convert DVI to PNG
      success, png_path = convert_latex_to_png(uid, dvi_path)
      unless success
        render json: { error: 'dvipng command did not succeed', input: params[:latex], output: png_path }, status: 500
        return
      end

      png_path
    end
  end

  def diagram
    image_request(:diagram) do
      success, png_path = convert_mermaid_to_png(params[:diagram])
      unless success
        render json: {
          error: 'mermaid command did not succeed',
          input: params[:diagram],
          output: png_path
        }, status: 500
        return
      end

      png_path
    end
  end

  private

  def image_request(param_name)
    if params[param_name].blank?
      render json: { error: "#{param_name} param was not found" }, status: 422
      return
    end

    uid = Digest::MD5.hexdigest(params[param_name])
    image_maker = ImageMaker.new
    remote_path = "images/#{param_name}/#{uid}.png"

    # Check for Cache
    if image_maker.exists?(remote_path)
      Rails.logger.info "Already made, sending cache"
      render json: { input: params[param_name], url: image_maker.url(remote_path) }
      return
    end

    path = yield(uid)
    return unless path

    # Send response
    json_hash = ImageMaker.new.create_image("#{uid}.png", remote_path, path.to_s)
    render json: { input: params[param_name], url: json_hash[:url] }
  end
end
