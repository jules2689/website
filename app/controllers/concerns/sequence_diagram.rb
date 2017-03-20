module SequenceDiagram
  def convert_mermaid_to_png(content)
    uid = Digest::MD5.hexdigest(content)
    file = Tempfile.new([uid, '.mmd'])
    file.write(content)
    file.flush

    output = `mermaid #{file.path} -w 2048 --png --outputDir #{TEMP_MERMAID}`
    file.close
    return [false, output] if $?.exitstatus != 0

    files = Dir["#{TEMP_MERMAID}/#{uid}*.png"]
    Rails.logger.info "Mermaid made a file at #{files.inspect}"
    return [false, output] if files.empty?

    [true, files.first]
  end
end
