class DiatexController < ApplicationController
  # http_basic_authenticate_with name: "diatex", password: Rails.application.secrets.diatex_password

  def latex
    if params[:tex].blank?
      render json: { error: 'tex param was not found' }, status: 422
      return
    end

    # LaTeX document skeleton
    document_top = "\\documentclass{article}
    \\usepackage{mathtools}
    \\usepackage{silence}
    \\everymath{\\displaystyle}
    \\begin{document}
    \\scrollmode
    \\pagestyle{empty}
    $"

    document_bottom = "$
    \\batchmode
    \\end{document}"

    # Prepare data
    uid = Digest::MD5.hexdigest(params[:tex])

    # Assemble the complete document source code (head + corp + foot)
    complete_tex_doc = [document_top, params[:tex], document_bottom].join

    # Write the tex file
    tex_file = Tempfile.new([uid, '.tex'])
    tex_file.write(complete_tex_doc)
    tex_file.flush

    # Convert to dvi
    Rails.logger.info "render tex @ #{tex_file.path}"
    output = `latex -8bit --interaction=nonstopmode -output-directory=#{TEMP_DVI} #{tex_file.path}`
    tex_file.close # Delete the tex file

    if $?.exitstatus != 0
      render json: { error: 'latex command did not succeed', input: params[:tex], output: output }, status: 500
      return
    end

    # Compute the complete dvi file path
    dvi_path = Dir["#{TEMP_DVI}/#{uid}*.dvi"].first
    unless File.exist?(dvi_path)
      render json: { error: 'dvi file did not exist' }, status: 422
      return
    end

    # Convert to png
    png_file = Tempfile.new([uid, '.png'])
    begin
      Rails.logger.info "render png @ #{png_file.path}"
      output = `dvipng -T tight -D 119 -o #{png_file.path} #{dvi_path}`
      if $?.exitstatus != 0
        render json: { error: 'dvipng command did not succeed', input: params[:tex], output: output }, status: 500
        return
      end

      # Clean up file system
      FileUtils.rm_rf(dvi_path)
      send_file png_file.path, type: 'image/png', disposition: 'inline'
    ensure
      png_file.close
    end
  end
end
