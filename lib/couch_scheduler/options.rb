module CouchScheduler
  class Options
    def initialize(options)
      @options = massage options.dup
    end

    def to_hash
      @options
    end
    
    private
    def massage(options)
      if !options[:startkey] && !options[:key]
        options = {:key => format_time(Time.now), :reduce => false}.merge options
      end
      
      [:key, :startkey, :endkey].each do |option|
        options[option] = format_time options[option] if options[option].kind_of?(Time)
      end

      options.delete :shown
      options.delete :hidden
      options.delete :published
      options.delete :unpublished

      options
    end

    def format_time(t)
      [t.year, t.month - 1, t.day, 0, 0, 0]
    end
  end
end
