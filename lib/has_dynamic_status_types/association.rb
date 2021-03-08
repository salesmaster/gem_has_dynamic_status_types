require 'active_record'
class HasDynamicStatusTypes::Association < ActiveRecord::Base

  self.table_name  = 'status_types'

  belongs_to :status_typeable, polymorphic: true

  before_save do |record|
    hist = self.history
    hist << { code: self.current_status_code, when: DateTime.now }
    record.previous_statuses_codes = hist.to_yaml
  end

  def history
    return [] unless self.previous_statuses_codes
    return YAML.load(self.previous_statuses_codes)
  end
end
