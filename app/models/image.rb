class Image < ApplicationRecord
    has_one :company
    has_one :news
end
