module CouchScheduler
  module CouchVisibleCouchPublishIntegration
    def self.included(base)
      base.couch_view :within_couch_schedule do
        map CouchScheduler::Map do
          conditions ::Published, ::Unpublished, ::Hidden, ::Shown
        end
      end
    end
  end
end
