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

module ApplicationHelper

  def error_messages!
    resource = current_user if resource.nil?
    resource = @user if resource.nil?
    return "" if  resource.nil? || resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join


    html = <<-HTML
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert"></button>
      <ul>#{messages}</ul>
    </div>
    HTML


    html.html_safe
  end

  def get_title
    @metamagic_renderer.tags.sort.first.value
  end

  def bs_will_paginate(collection)
  will_paginate collection, renderer: BootstrapPagination::Rails
 end
end
