module CouchScheduler
  def self.included(base)
    base.property :start, Time
    base.property :end, Time
    base.validate :validate_start_and_end
    base.view_by :couch_schedule, :map => '
      function(doc){
        var start = doc.start ? new Date(doc.start) : new Date(2011, 0, 1, 0, 0, 0, 0)
        var end   = doc.end   ? new Date(doc.end  ) : new Date(2025, 0, 1, 0, 0, 0, 0)
        
        while(start < end){
          emit(
            [
              start.getFullYear(), 
              start.getMonth(), 
              start.getDate(), 
              0, 
              0,
              0
            ], 
            null
          );
          start.setDate(start.getDate() + 1)
        }
      }
    ', :reduce => '_count'
    base.extend ClassMethods
  end

  module ClassMethods
    def by_schedule(options={})
      if !options[:startkey] && !options[:key]
        options = {:key => format_time(Time.now), :reduce => false}.merge options
      end
      
      [:key, :startkey, :endkey].each do |option|
        options[option] = format_time options[option] if options[option].kind_of?(Time)
      end

      by_couch_schedule options
    end

    def count_by_schedule(options={})
      result = by_schedule(options.merge(:reduce => true))['rows'].first
      result ? result['value'] : 0
    end

    private
    def format_time(t)
      [t.year, t.month - 1, t.day, 0, 0, 0]
    end
  end

  def within_schedule?
    start_valid = true
    end_valid   = true

    start_valid = Time.now >= self.start  if self.start
    end_valid   = Time.now < self.end     if self.end

    start_valid && end_valid
  end

  private
  def validate_start_and_end
    errors[:end] = "must be greater than start" unless self.end > self.start
  end
end
