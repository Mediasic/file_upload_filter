# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FileUploadFilterExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/file_upload_filter"
  
  define_routes do |map|
    map.connect 'admin/file_upload_filter/:action', :controller => 'admin/file_upload_filter'
  end
  
  def activate
    # Load the filter
    FileUploadFilter
    
    
    # Add the appropriate stylesheets to the javascripts array in the page and snippet controller
    Admin::PageController.class_eval do
      before_filter :add_file_upload_filter_includes, :only => [:edit, :new]
      
      def add_file_upload_filter_includes
        @javascripts << 'extensions/file_upload_filter/file_upload_filter'
        @stylesheets << 'extensions/file_upload_filter/file_upload_filter'
      end
      
    end
    
    Admin::SnippetController.class_eval do
      before_filter :add_file_upload_filter_includes, :only => [:edit, :new]
      
      def add_file_upload_filter_includes
        @javascripts << 'extensions/file_upload_filter/file_upload_filter'
        @stylesheets << 'extensions/file_upload_filter/file_upload_filter'
      end
      
    end
    
  end
  
  def deactivate
  end
  
end