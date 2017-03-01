module Latex
  def convert_latex_to_dvi(uid, params)
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

    return [false, output] if $?.exitstatus != 0
    [true, Dir["#{TEMP_DVI}/#{uid}*.dvi"].first]
  end

  def convert_latex_to_png(uid, dvi_path)
    png_file = Tempfile.new([uid, '.png'])
    Rails.logger.info "render png @ #{png_file.path}"
    output = `dvipng -T tight -D 119 -o #{png_file.path} #{dvi_path}`
    return [false, output] if $?.exitstatus != 0

    [true, png_file.path]
  ensure
    FileUtils.rm_rf(dvi_path)
  end
end
