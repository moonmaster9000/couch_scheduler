module CouchScheduler
  def self.included(base)
    base.property :start, Time
    base.property :end, Time
    base.validate :validate_start_and_end
    base.view_by :couch_schedule, :map => Map.new(base).to_s, :reduce => '_count'
    base.extend ClassMethods

    if defined?(CouchPublish) && base.ancestors.include?(CouchPublish)
      base.send :include, CouchPublishIntegration
    end

    if defined?(CouchVisible) && base.ancestors.include?(CouchVisible)
      base.send :include, CouchVisibleIntegration
    end

    if defined?(CouchVisible) && base.ancestors.include?(CouchVisible) && defined?(CouchPublish) && base.ancestors.include?(CouchPublish)
      base.send :include, CouchVisibleCouchPublishIntegration
    end
  end

  module ClassMethods
    def by_schedule(options={})
      by_couch_schedule CouchScheduler::TimeMassager.massage(options)
    end

    def count_schedule(options={})
      count_by_map :by_schedule, options
    end

    private
    def count_by_map(map, options)
      result = self.send(map, options.merge(:reduce => true))['rows'].first
      result ? result['value'] : 0
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
