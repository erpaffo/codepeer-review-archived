# app/helpers/file_helper.rb
module FileHelper
  def ensure_extension(path, content = nil)
    extension = Pathname.new(path).extname
    return path if extension.present?

    detected_extension = detect_extension_from_content(content)
    if detected_extension
      path += ".#{detected_extension}"
    else
      Rails.logger.warn "Unable to determine extension for #{path}"
    end
    path
  end

  private

  def detect_extension_from_content(content)
    type = Marcel::MimeType.for(StringIO.new(content))
    if type
      MIME::Types[type].first.extensions.first
    else
      nil
    end
  end
end
