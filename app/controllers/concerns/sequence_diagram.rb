module SequenceDiagram
  def convert_mermaid_to_png(content)
    uid = Digest::MD5.hexdigest(content)
    file = Tempfile.new([uid, '.mmd'])
    file.write(content)
    file.flush

    # Run the command. This should output a file at `file.path` + .png
    cmd_path = Rails.root.join('scripts', 'mermaid_online.js')
    cmd = "phantomjs #{cmd_path} #{file.path}"
    Rails.logger.info "Running `#{cmd}`"
    output = `#{cmd}`

    # If not successful, return
    if $?.exitstatus != 0
      file.close
      return [false, output]
    end

    # Make sure the file exists
    svg_file = file.path + ".svg"
    Rails.logger.info "Mermaid made a file at #{svg_file}"
    unless File.exist?(svg_file)
      file.close
      return [false, output]
    end

    # Make sure the picture exists
    png_file = file.path + ".png"
    system("convert #{svg_file} #{png_file}")
    unless File.exist?(png_file)
      file.close
      return [false, output]
    end

    file.close
    [true, png_file]
  end
end
