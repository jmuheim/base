# encoding: utf-8

class DocumentUploader < AbstractUploader
  def extension_whitelist
    %w(txt md doc docx pdf)
  end
end
