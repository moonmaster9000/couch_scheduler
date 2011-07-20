module CouchScheduler
  class Map
    def initialize(original_base, *args)
      @base     = original_base
      @options  = [:base_check] + args
    end

    def to_s
      %{
        function(doc){
          if (#{conditions}){
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
      }
    end
    
    private
    def conditions
      @options.map do |option|
        self.send option
      end.join " && "
    end

    def base_check
      "doc['couchrest-type'] == '#{@base.to_s}'"
    end

    def shown
      "doc.couch_visible === true"
    end

    def hidden
      "doc.couch_visible === false"
    end

    def published
      "doc.milestone_memories.length > 0"
    end

    def unpublished
      "doc.milestone_memories.length == 0"
    end
  end
end
