class FileUploadFilter < TextFilter
  filter_name "FileUpload"
  description_file File.dirname(__FILE__) + "/../tinymce.html"
  def filter(text)
    text
  end
end