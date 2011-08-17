module CouchScheduler
  module CouchPublishIntegration
    def self.included(base)
      base.couch_view :within_couch_schedule do
        map CouchScheduler::Map do
          conditions ::Published, ::Unpublished
        end
      end
    end
  end
end

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
