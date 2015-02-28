# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ExampleStore::Application.initialize!

# Initialize PayuIndia Gateway config
require 'payu_india/action_view_helper'
ActionView::Base.send(:include, PayuIndia::ActionViewHelper)