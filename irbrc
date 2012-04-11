# Basic settings
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:EVAL_HISTORY] = 10
IRB.conf[:USE_READLINE] = true

# Requirements
require 'rubygems'

# Object.ri lookups (with optional /method/ grepping)
require 'ori' # enables object.ri lookups
ORI.conf.frontend = 'ri --no-gems -T -f ansi %s'

# Awesome_Print (ap)
require 'ap'
unless IRB.version.include?('DietRB')
  IRB::Irb.class_eval do
    def output_value; ap @context.last_value; end
  end
else # MacRuby
  IRB.formatter = Class.new(IRB::Formatter) do
    def inspect_object(object); object.ai; end
  end.new
end

if defined?(RAILS_ENV) # {{{ Rails SQL logger
  # Called after the irb session is initialized and Rails has been loaded
  IRB.conf[:IRB_RC] = Proc.new do
    logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = logger
    ActiveResource::Base.logger = logger
  end
end # }}}

class Object
  def unique_methods
    (self.methods - Object.instance_methods).sort
  end
end
