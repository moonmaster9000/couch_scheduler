module CouchScheduler
  def self.included(base)
    base.property :start, Time
    base.property :end, Time
    base.validate :validate_start_and_end
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
