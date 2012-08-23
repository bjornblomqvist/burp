module Burp
  class Access
    
    def initialize(data)
    end
    
    # If true no http auth check will be made. (Ment as a way to remove Burp's default auth method.)
    def may_skip_http_auth
      false
    end
    
    # Static pages in the CMS
    def may_view_static_page(action)
      true
    end
    
    
    
    # CMS pages
    def may_view_page_list
      true
    end
    
    def may_create_new_page
      true
    end
    
    def may_edit_page(page)
      true
    end
    
    def may_update_page(page)
      true
    end
    
    def may_remove_page(page)
      true
    end
    
    def may_view_page_data(page)
      true
    end
    
    
    # CMS files
    def may_view_file_list
      true
    end
    
    def may_upload_a_file
      true
    end
    
    def may_view_file(path)
      true
    end
    
  end
end