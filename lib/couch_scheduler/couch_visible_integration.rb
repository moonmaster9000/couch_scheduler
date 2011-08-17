module CouchScheduler
  module CouchVisibleIntegration
    def self.included(base)
      base.couch_view :within_couch_schedule do
        map CouchScheduler::Map do
          conditions ::Shown, ::Hidden
        end
      end
    end
  end
end
