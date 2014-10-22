# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

class Sponsor < ActiveRecord::Base
  belongs_to :conference

  has_attached_file :logo, :styles => { :default => "360x230>", :thumb => "200x200", :small => "50x50"}
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
end
