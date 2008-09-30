var existing_urls = [];
var uploads_to_save = [];

function file_upload_filter_input_method(index, filter)
{
   if (index != null)
   {
      // control for page parts
      var elem = $('part_'+index+'_content');
      var file_url = elem.value;
      var has_file = file_url != '';
      
      if(has_file) existing_urls[index] = $('part_' + index + '_content').value;

      if (filter == "FileUpload")
      {
         var out = "<div class=\"file_upload_filter\" id=\"file_upload_filter_" + index + "\">"
          + "  <div class=\"file_upload_filter_file_link\">"
          + "    <a " + (has_file ? "href=\"" + file_url + "\"" : "style=\"display: none;\"") + " id=\"file_upload_filter_" + index + "_file\"/>View File</a>"
          + "  </div>"
          + "  <div class=\"file_upload_filter_options\">"
          + "    <select class=\"file_upload_filter_select\" id=\"file_upload_filter_" + index + "_select\">View File</a>"
          + "      <option value=\"no_file\">No File</option>"
          + "      " + (has_file ? "<option value=\"keep_same_file\" selected=\"selected\">Keep Same File</option>" : "") + ""
          + "      <option value=\"upload_new_file\"" + (!has_file ? " selected=\"selected\"" : "") + ">Upload new File</option>"
          + "    </select>"
          + "    <div class=\"file_upload_filter_file_wrap\" id=\"file_upload_filter_" + index + "_file_wrap\"" + (has_file ? " style=\"display: none;\"" : "") + ">"
          + "      <iframe class=\"file_upload_filter_iframe\" id=\"file_upload_filter_" + index + "_iframe\" src=\"/admin/file_upload_filter/upload\" frameborder=\"no\"></iframe>"
          + "      <input type=\"button\" id=\"file_upload_filter_" + index + "_file_submit\" value=\"Upload!\" />"
          + "    </div>"
          + "  </div>"
          + "  <div class=\"file_upload_filter_clear\"></div>"
          + "</div>";
         elem.up().insert(out);

         Event.observe($("file_upload_filter_" + index + "_select"), 'change', function(e) {
            var ele = e.element();
            if(ele.value == 'no_file')
            {
               $("file_upload_filter_" + index + "_file").href = "about:blank";
               $("file_upload_filter_" + index + "_file").style.display = "none";
               $('part_' + index + '_content').value = 'about:blank';
               $("file_upload_filter_" + index + "_file_wrap").style.display = "none";
            }
            else if(ele.value == 'keep_same_file')
            { 
               $("file_upload_filter_" + index + "_file").href = existing_urls[index];
               $("file_upload_filter_" + index + "_file").style.display = "";
               $('part_' + index + '_content').value = existing_urls[index];
               $("file_upload_filter_" + index + "_file_wrap").style.display = "none";
            }
            else if(ele.value == 'upload_new_file')
            {
               $("file_upload_filter_" + index + "_file").href = "about:blank";
               $("file_upload_filter_" + index + "_file").style.display = "none";
               $('part_' + index + '_content').value = existing_urls[index];
               $("file_upload_filter_" + index + "_file_wrap").style.display = "";
            }
         });

         Event.observe($("file_upload_filter_" + index + "_file_submit"), 'click', function(e)
         {
            var frame = $("file_upload_filter_" + index + "_iframe");
            var doc = frame.contentDocument || frame.contentWindow.document;
            var form = doc.forms[0];
            form.elements[1].value = index;
            if(form.elements[2].value != "") form.submit();
         });
         setTimeout("$('part_"+index+"_content').style.display = 'none'", 1);
      }
      else
      {
         
      }
   }
   else
   {
      //ignore for snippets
   }
}

Event.observe(window, 'load', init_load_file_upload_filter, false);

function init_load_file_upload_filter()
{
   // loads FileUpload editor if "FileUpload" is the selected text filter

   // check to see if we are working with a page or with a snippet
   if($('part[0][filter_id]') || $('part_0_filter_id'))
   {
      parts = $('pages').getElementsByTagName('textarea');
      for(var i = 0; i < parts.length; i++)
      {
         select = $('part[' + i + '][filter_id]') || $('part_' + i + '_filter_id')
         if ($F(select) == 'FileUpload')
         {
            file_upload_filter_input_method(i, 'FileUpload');
         }

         Event.observe(select, 'change', function(event)
         {
            element = Event.element(event);
            id = parseInt(element.id.replace("part[", "").replace("][filter_id]").replace("part_", "").replace("_filter_id"));
            file_upload_filter_input_method(id, $F(element));
         });

      }
   }
   else if($('snippet[filter_id]')) 
   {
      if($F('snippet[filter_id]') == 'FileUpload') 
      {
         file_upload_filter_input_method(null, 'FileUpload');
      }

      Event.observe($('snippet[filter_id]'), 'change', function(event)
      {
         element = Event.element(event);
         file_upload_filter_input_method(null, $F(element));
      });
   }
}

function file_upload_filter_finish_upload(index, url)
{
   $("part_" + index + "_content").value = url;
   $("file_upload_filter_" + index + "_file").href = url;
   $("file_upload_filter_" + index + "_file").style.display = "";
}