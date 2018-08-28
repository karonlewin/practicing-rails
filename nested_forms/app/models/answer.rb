class Answer < ApplicationRecord
  # attr_accessible :content
  belongs_to :question
end
