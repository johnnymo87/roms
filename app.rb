#!/Users/jonmohrbacher/.rvm/rubies/ruby-2.3.1/bin/ruby

abort (<<-MSG) if ARGV.size != 2
Aborting!
This script takes a "from" URL and a "to" diretory
Example:
/Neo-Geo_CD_ISOs/8 /Volumes/USB30FD/retropie/roms/neogeo
MSG

module DownloadHelpers
  TIMEOUT = 60
  PATH    = ARGV[1]

  def self.downloads
    Dir["#{PATH}/*"]
  end

  def self.incomplete_downloads
    downloads.grep(/\.crdownload$/)
  end

  def self.wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.5 until incomplete_downloads.none?
    end
  end
end

require 'capybara/dsl'
require 'selenium/webdriver'

include Capybara::DSL

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'http://www.emuparadise.me/'
end

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile["download.default_directory"] = DownloadHelpers::PATH
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
end
Capybara.javascript_driver = :chrome

def visit_root
  visit ARGV[0]
end

def matches
  find('.col_4.suf_1').all('a')
end

def download_rom
  if page.has_css?('#skip-captcha')
    find('#skip-captcha').click
  end
  find('#download-link').click
  DownloadHelpers.wait_for_download
end

def visit_download_page(n, &block)
  anchor_node = matches[n]
  href = "#{anchor_node['href']}-download"
  puts href
  begin
    visit href
  rescue URI::InvalidURIError
    anchor_node.click
    find('.download-link a').click
  end
  block.call
  visit_root
  sleep until matches.any?
end

visit_root
matches.size.times do |n|
  Timeout.timeout(DownloadHelpers::TIMEOUT * 2) do
    visit_download_page(n) do
      download_rom
    end
  end
end
