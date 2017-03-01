# Main Path
output_temp_dir = Rails.root.join('tmp/diatex')
FileUtils.mkdir_p(output_temp_dir) unless File.exists?(output_temp_dir)

# Temporary dvi file
TEMP_DVI = "%s/dvi" % output_temp_dir
FileUtils.mkdir_p(TEMP_DVI) unless File.exists?(TEMP_DVI)
