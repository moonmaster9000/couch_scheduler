module CouchScheduler
  module Conditions
    module Published
      def conditions
        "#{super} && doc.milestone_memories.length > 0"
      end
    end

    module Unpublished
      def conditions
        "#{super} && doc.milestone_memories.length == 0"
      end
    end

    module Shown
      def conditions
        "#{super} && doc.couch_visible == true"
      end
    end

    module Hidden
      def conditions
        "#{super} && doc.couch_visible == false"
      end
    end
  end
end
