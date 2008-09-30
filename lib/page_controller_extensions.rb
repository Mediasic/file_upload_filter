module PageControllerExtensions
  class << self
    def included(base)
      base.class_eval
        alias_method :save_without_mods, :save
        def save_with_mods
          keys = params.keys.select { |p| p =~ /file_upload_filter_\d+_file/ }
          keys.each do |key|
            
        end
      EOF
    end
  end
end