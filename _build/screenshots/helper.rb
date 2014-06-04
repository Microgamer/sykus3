require 'bundler'
Bundler.setup

require 'fileutils'

require 'capybara'
require 'selenium-webdriver'
require 'capybara/rspec'

require_relative 'helper_methods'

WEBIF_BASE = 'https://sykus-demo.de'
BROWSER_WIDTH = 1024

RSpec.configure do |c|
  c.include HelperMethods

  c.before :each do
    # 15px scrollbar fix; height does not matter for screenshot
    page.driver.browser.manage.window.resize_to (BROWSER_WIDTH + 15), 1024
  end

  c.after :each do
    # blur selected element and wait for page to render completely
    sleep 0.5
    find('body').click
    sleep 0.2

    dir = example.metadata[:example_group][:description_args].first.strip
    file = example.metadata[:description_args].first.strip + '.png'

    outdir = File.join(File.dirname(__FILE__), 'output', dir)
    FileUtils.mkdir_p outdir

    page.save_screenshot File.join(outdir, file)
  end
end

profile = Selenium::WebDriver::Firefox::Profile.new
profile['extensions.adblockplus.currentVersion'] = '1.3.10'

Capybara.register_driver :my_driver do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile)
end

Capybara.default_driver = :my_driver
Capybara.run_server = false
Capybara.app_host = WEBIF_BASE

