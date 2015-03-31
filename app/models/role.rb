# == Schema Information
# Schema version: 20140626201417
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_id   :integer
#  resource_type :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_roles_on_name                                    (name)
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  scopify
end
