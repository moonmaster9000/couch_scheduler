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
