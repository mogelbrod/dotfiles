require 'rubygems'

begin
  colors = { # {{{ Wirble colors
    # delimiter colors
    :comma              => :white,
    :refers             => :white,

    # container colors (hash and array)
    :open_hash          => :white,
    :close_hash         => :white,
    :open_array         => :white,
    :close_array        => :white,

    # object colors
    :open_object        => :light_red,
    :object_class       => :white,
    :object_addr_prefix => :dark_gray,
    :object_line_prefix => :blue,
    :close_object       => :light_red,

    # symbol colors
    :symbol             => :light_green,
    :symbol_prefix      => :light_green,

    # string colors
    :open_string        => :blue,
    :string             => :light_purple,
    :close_string       => :blue,

    # misc colors
    :number             => :purple,
    :keyword            => :brown,
    :class              => :red,
    :range              => :blue,
  } # }}}

  require 'wirble'
  Wirble::Colorize.colors = colors
  Wirble.init
  Wirble.colorize
rescue LoadError => ex
  warn "Wirble gem failed to load: #{ex}"
end

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:EVAL_HISTORY] = 10
IRB.conf[:USE_READLINE] = true

if defined?(RAILS_ENV)
  # Called after the irb session is initialized and Rails has been loaded
  IRB.conf[:IRB_RC] = Proc.new do
    logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = logger
    ActiveResource::Base.logger = logger
  end
end

def colputs(array) # {{{
  def num_columns; 4; end
  def col_width; 20; end
  def force_length(x)
    x = x.to_s
    max_length = col_width+2
    if x.length > max_length
      x = x[0..max_length-4] + '...'
    end
    x += (' '*max_length)
    x[0..max_length-1]
  end
  def get_element(array, i) # displays in column order instead of row order
    num_rows = (array.length/num_columns)+1
    col = i % num_columns
    row = i / num_columns
    array[col*num_rows+row]
  end
  for i in (0..array.length)
    print force_length(get_element(array, i))
    print "  "
    puts if (i % num_columns) == (num_columns-1)
  end
  nil
end # }}}

class Object
  def unique_methods
    colputs (self.methods - Object.instance_methods).sort
  end
end
