# Main Path
output_temp_dir = Rails.root.join('tmp', 'diatex').freeze
FileUtils.mkdir_p(output_temp_dir) unless File.exist?(output_temp_dir)

# Temporary dvi file
TEMP_DVI = "#{output_temp_dir}/dvi".freeze
FileUtils.mkdir_p(TEMP_DVI) unless File.exist?(TEMP_DVI)

# Temporary Mermaid
TEMP_MERMAID = "#{output_temp_dir}/mermaid".freeze
FileUtils.mkdir_p(TEMP_MERMAID) unless File.exist?(TEMP_MERMAID)

# Temporary dvi file
TEMP_IMAGES = "#{output_temp_dir}/images".freeze
FileUtils.mkdir_p(TEMP_IMAGES) unless File.exist?(TEMP_IMAGES)
