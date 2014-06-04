module HelperMethods

  def log_in(admin = false)
    visit '/'

    find('#field-username').set (admin ? 'admin' : 'hoffmannnico')
    find('#field-password').set 'demo'
    find('.js-btn-submit').click
    
    fix_size
  end

  def fix_size
    page.execute_script 'document.body.style.minHeight = "3000px";'
  end

end

