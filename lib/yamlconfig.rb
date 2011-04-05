# $Id: yamlconfig.rb 84 2008-01-29 02:04:40Z cmaujean $
# 
# See LICENSE for copyright information
#

require 'yaml'

# This class represents a configuration, using a YAML file,
# by providing "accessor" methods for each item in the YAML file
class YAMLConfig
	attr_accessor :resource
	include Enumerable

	def initialize(resource)
		@specialmethods = Array.new
		@resource = resource

		# initial method load
		reload()
	end

	#
	# This method is provided for keys and other structures where
	# getting at the method call is impossible.
	#
	# This will return 'nil' for all values if the YAML you have loaded
	# is improperly formed.
	#

	def [](key)
		if !@con.nil?
			return @con[key]
		end

		nil
	end

	#
	# This is a writer in the same spirit as the [] method. Please read
	# the documentation for that.
	#
	
	def []=(key, value)
		if !@con.nil?
			return @con[key] = value
		end

		nil
	end
  
  #
  # this should take a [] capable object, add it (keys and values) to 
  # self, and return self
  #

  def +(other)
    if !@con.nil?
      other.each do |k, v|
        # add it to con
        @con[k] = v
        
        # add it as a method
        (class << self; self; end).class_eval { define_method(k) { v }}

        #add it to the @specialmethods array
        @specialmethods.push k
      end
    end
    self
  end

	#
	# Rewrite and reload the yaml file. Note, that this will overwrite your current
	# yaml file and reload your configuration. If you want to avoid
	# doing this, provide the path to a filename for it to work with.
	#

	def write(io=@resource)
		# Some duck-typing checks to make sure we're dealing with
		# something that looks like an IO object.
	
		f = File.open(io, 'w')

		f << YAML::dump(@con)

		if io == @resource
			f.reopen(io, 'r')
			reload
		end

		true
	end

	# Remove all current (if any) attr_readers, then load the resource 
	# named in @resource into psuedo attr_readers
	def reload
		# first remove all the previous methods from this instance
		
    if @specialmethods
      @specialmethods.each do |meth|
          (class << self; self; end).class_eval { undef_method(meth) }  
      end
    end

		# wipe the old list
		@specialmethods = []

		# then load the new methods
		# add a method to the Singleton class of this instance of Config.
		# giving a private readonly accessor named "key" that returns "value" for each 
		# key value pair of the YAML file named in @filename
		@con = loadresource()
    if @con
      @con.each do |key,value|
        (class << self; self; end).class_eval { define_method(key) { value }}

        #add it to the @specialmethods array
        @specialmethods.push key
      end
    end
	end
	
	# standard each usage, iterates over the config keys
	# returning key,value
	def each
		@specialmethods.each do |key|
			yield key, self.send(key)
		end
	end


	#--
	# End of public documentation
	private

	def loadresource()
		# TODO, make this take plugins or some sort of adapter type scheme for 
		# deciding how to load what into a hash
		YAML.load_file(@resource) || { }
	end
end

require 'yamlconfig/version'

# vi:sw=2 ts=2
