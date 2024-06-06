require 'yaml'

module FileExtensionHelper
  def ensure_extension(path, content = nil)
    return path if Pathname.new(path).extname.present?

    extension = file_extensions.find { |ext, patterns| patterns.any? { |pattern| content&.include?(pattern) } }
    path += ".#{extension.first}" if extension
    path
  end

  private

  def file_extensions
    @file_extensions ||= load_file_extensions
  end

  def load_file_extensions
    YAML.load_file(Rails.root.join('config', 'file_extensions.yml'))['extensions']
  end
end
