module SequenceDiagram
  def convert_mermaid_to_png(content)
    uid = Digest::MD5.hexdigest(content)
    file = Tempfile.new([uid, '.mmd'])
    file.write(content)
    file.flush

    output = `mermaid #{file.path} --png --outputDir #{TEMP_MERMAID}`
    file.close
    return [false, output] if $?.exitstatus != 0

    file = Dir["#{TEMP_MERMAID}/#{uid}*.png"].first
    Rails.logger.info "Mermaid made a file at #{file}"
    return [false, output] if file.nil? || !File.exist?(file)

    [true, Dir["#{TEMP_MERMAID}/#{uid}*.png"].first]
  end
end
