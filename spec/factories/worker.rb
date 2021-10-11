# frozen_string_literal: true

FactoryBot.define do
  factory :worker do
    name { 'John' }
    last_name { 'Doe' }
    role { 'software_engineer' }
    email { 'john@doe.com' }
  end
end
