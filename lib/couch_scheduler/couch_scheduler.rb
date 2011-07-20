module CouchScheduler
  def self.included(base)
    base.property :start, Time
    base.property :end, Time
    base.validate :validate_start_and_end
    base.view_by :couch_schedule, :map => %{
      function(doc){
        if (doc["couchrest-type"] == "#{base}"){
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
      }
    }, :reduce => '_count'
    base.extend ClassMethods
    if defined?(CouchPublish) && base.ancestors.include?(CouchPublish)
      base.send :include, CouchPublishIntegration
    end
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

    def count_schedule(options={})
      result = by_schedule(options.merge(:reduce => true))['rows'].first
      result ? result['value'] : 0
    end

    private
    def format_time(t)
      [t.year, t.month - 1, t.day, 0, 0, 0]
    end
  end

  module CouchPublishIntegration
    def self.included(base)
      base.extend ClassMethods
      base.view_by :couch_schedule_and_unpublished, :map => %{
        function(doc){
          if (doc["couchrest-type"] == "#{base}" && doc.milestone_memories.length == 0){
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
        }
      }, :reduce => '_count'

      base.view_by :couch_schedule_and_published, :map => %{
        function(doc){
          if (doc["couchrest-type"] == "#{base}" && doc.milestone_memories.length > 0){
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
        }
      }, :reduce => '_count'
    end

    module ClassMethods
      def by_schedule_and_published(options={})
        if !options[:startkey] && !options[:key]
          options = {:key => format_time(Time.now), :reduce => false}.merge options
        end
        
        [:key, :startkey, :endkey].each do |option|
          options[option] = format_time options[option] if options[option].kind_of?(Time)
        end

        by_couch_schedule_and_published options
      end

      def by_schedule_and_unpublished(options={})
        if !options[:startkey] && !options[:key]
          options = {:key => format_time(Time.now), :reduce => false}.merge options
        end
        
        [:key, :startkey, :endkey].each do |option|
          options[option] = format_time options[option] if options[option].kind_of?(Time)
        end

        by_couch_schedule_and_unpublished options
      end

      def count_schedule_and_published(options={})
        result = by_schedule_and_published(options.merge(:reduce => true))['rows'].first
        result ? result['value'] : 0
      end

      def count_schedule_and_unpublished(options={})
        result = by_schedule_and_unpublished(options.merge(:reduce => true))['rows'].first
        result ? result['value'] : 0
      end
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
    if self.end && self.start && self.end < self.start
      errors[:end] = "must be greater than start"
    end
  end
end
