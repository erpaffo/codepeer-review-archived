class ProjectFile < ApplicationRecord
  belongs_to :project

  validates :name, presence: true
  validates :size, numericality: { less_than_or_equal_to: 50.megabytes }

  def human_readable_size
    ActiveSupport::NumberHelper.number_to_human_size(size)
  end
end
