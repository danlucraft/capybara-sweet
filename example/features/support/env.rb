
require 'capybara'
require 'capybara/dsl'

$:.push(File.dirname(__FILE__) + "/../../../lib/")
require 'capybara/driver/sweet'
require 'capybara_sweet'

Capybara.default_driver = :sweet
Capybara.app_host = "http://localhost:3000"

World(Capybara)