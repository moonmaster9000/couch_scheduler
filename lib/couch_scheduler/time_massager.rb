module CouchScheduler
  module TimeMassager
    extend self

    def massage(options)
      if !options[:startkey] && !options[:key]
        options = {:key => format_time(Time.now), :reduce => false}.merge options
      end
      
      [:key, :startkey, :endkey].each do |option|
        options[option] = format_time options[option] if options[option].kind_of?(Time)
      end

      options
    end

    private
    def format_time(t)
      [t.year, t.month - 1, t.day, 0, 0, 0]
    end
  end
end
