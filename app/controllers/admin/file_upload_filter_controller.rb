require 'image_science'

=begin
Thumbnailing documentation (specific in some regards to ANAT):
Given an original image of x pixels high and y pixels wide, x >= 160 and y >= 160:
  - The small image (width of a = 85, height of b = 50) is produced by:
    - If the original image has x > y (i.e. is portrait):
      - Scale the original image on the width to be a wide.
      - Crop the resulting image equally from the top and bottom so it is b pixels high.
    - Else if the original image has x <= y (i.e. is landscape or square):
      - Scale the original image on the height to be b tall.
      - Crop the resulting image equally from the left and right so it is a pixels wide.
  - The medium image (width of a = 160, height of b = 110 except for members where it is 160) is produced by:
    - If the original image has x > y (i.e. is portrait):
      - Scale the original image on the width to be a wide.
      - Crop the resulting image equally from the top and bottom so it is b pixels high.
    - Else if the original image has x <= y (i.e. is landscape or square):
      - Scale the original image on the height to be b tall.
      - Crop the resulting image equally from the left and right so it is a pixels wide.
  - The large image is produced by:
    - If the original image has x > y (i.e. is portrait):
      - Scale the original image on the height to be 500 pixels tall.
    - Else if the original image has x <= y (i.e. is landscape or square):
      - Scale the original image on the height to be 700 pixels wide.
=end

class ImageScience
  WAY_WIDTH = 0
  WAY_HEIGHT = 1

  def forced_thumbnail(size, side = WAY_WIDTH) # :yields: image
    w, h = width, height
    scale = size.to_f / (side == WAY_WIDTH ? w : h)

    self.resize((w * scale).to_i, (h * scale).to_i) do |image|
      yield image
    end
  end

  #given a width and a height, and a way:
  #if way = width
  #  scale so  width = width, then crop height to height
  #else if way = height
  #  scale so height = height, then crop width to width
  #end
  def cropped_thumbnail2(width, height, side = WAY_WIDTH) # :yields: image
    w, h = self.width, self.height
    scale = (portrait? ? (width / w.to_f) : (height / h.to_f))
    new_height = (h * scale)
    new_width = (w * scale)
    crop_top = [(h > height ? ((new_height - height) / 2) : 0), 0].max
    crop_left = [(w > width ? ((new_width - width) / 2) : 0), 0].max
 
    #puts "w: #{w}, h: #{h}, width: #{width}, height: #{height}, scale: #{scale}, new_width: #{new_width}, new_height: #{new_height}, crop_top: #{crop_top}, crop_left: #{crop_left}, crop_bottom: #{new_height - crop_top}, crop_right: #{new_width - crop_left}"

    self.resize(new_width.round, new_height.round) do |img|
      img.with_crop(crop_left.round, crop_top.round, (new_width - crop_left).round, (new_height - crop_top).round) do |thumb|
        yield thumb
      end
    end
  end

  def portrait?
    height > width
  end

  def landscape?
    width > height
  end

  def square?
    width == height
  end
end


class Admin::FileUploadFilterController < ApplicationController
  def upload
    if request.post?
      file_data = params[:file]
      url = "/images/file_upload_filter/#{Time.now.to_i.to_s}_#{rand(1000000)}_#{file_data.original_filename}"
      index = params[:index]
      out_path = "public#{url}"

      file_data.rewind
      if file_data.is_a? Tempfile
        path = file_data.local_path
      else
        tf = Tempfile.new("temp_file_upload_filter")
        tf << file_data.read
        tf.flush
        path = tf.path
      end

      File.cp(path, out_path)
      File.chmod(0755, out_path)

      tf.close! unless tf.nil?

      @scripts = " onload=\"parent.file_upload_filter_finish_upload(#{index}, '#{url}');\""
    else
      @scripts = ""
    end
    render :action => 'upload', :layout => false
  end
end