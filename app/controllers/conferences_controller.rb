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

class ConferencesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_action :set_conference, only: [:show, :edit, :update, :destroy, :manage, :schedule, :basic_information, :address, :contact_information, :appeal_types, :landing_settings]
  before_action :load_data, only: [:new, :edit, :update]
  before_action :parse_dates, only: [:edit, :basic_information]

  layout 'conference_landing', :only => [:show]
  # GET /conferences
  # GET /conferences.json
  def index
    @conferences = current_user.conferences.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferences }
    end
  end

  # GET /conferences/1
  # GET /conferences/1.json
  def show
    @slot = Slot.new #for schedule showing
    @one_day = (@conference.days.first == @conference.days.last)
    @appeal = @conference.appeals.new
    @appeal.build_topic
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/new
  # GET /conferences/new.json
  def new

    @wizard = current_user.conference_wizard

    if @wizard.present?
      conf_params = Rack::Utils.parse_nested_query @wizard.data
      @conference = Conference.new(conf_params["conference"])
      @conference.build_address if @conference.address.nil?
      @conference.appeal_types.build if @conference.appeal_types.nil?
    else
      @conference = Conference.new
      @conference.build_address
      @conference.appeal_types.build
      @wizard = current_user.build_conference_wizard
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/1/edit
  def edit
    @conference.email_templates.build
  end

  # POST /conferences
  # POST /conferences.json
  def create
    @conference = Conference.new(conference_params)

    respond_to do |format|
      if @conference.save
        current_user.conference_wizard.destroy if current_user.conference_wizard
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
      else
        format.html { render action: "new" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update

    respond_to do |format|
      if @conference.update_attributes(conference_params)
        format.html { redirect_to manage_conference_path(@conference), notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.json
  def destroy
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end

  def schedule
    @room = Room.new
    @slot = Slot.new
  end

  def appeal_types
    @appeal_types = @conference.appeal_types

    respond_to do |format|
      format.json { render json: @appeal_types }
      format.html { render template: "conferences/edit/appeal_types"}
    end
  end

  #admin side #show equivalent
  def manage
    @latest_appeals = @conference.appeals.order("created_at DESC").limit(15).includes(topic: [:speakers]).includes(:comments)
    @total_appeals = @conference.appeals
    @waiting_appeals = @conference.appeals.where(:state => "waiting_review")
    @activities = @conference.activities.order("created_at DESC").limit(15)
  end

  def check_slug
    if Conference.where(slug: check_slug_params[:slug]).count == 0
      render :json => true
    else
      render :json => false
    end
  end

  def sync_wizard
    @wizard = current_user.conference_wizard
    @wizard ||= current_user.build_conference_wizard

    respond_to do |format|
      if @wizard.update_attribute("data", sync_wizard_params[:data])
        format.js
      else
        format.js
      end
    end
  end

  def reset_wizard
    current_user.conference_wizard.destroy if current_user.conference_wizard

    redirect_to new_conference_path
  end

  def basic_information
    render template: "conferences/edit/basic_information"
  end

  def address
    render template: "conferences/edit/address"
  end

  def contact_information
    render template: "conferences/edit/contact_information"
  end

  def landing_settings
    @modules = Conference::MODULES
  end

  private

    def parse_dates
      @conference.to_date = @conference.days.last.date.strftime(I18n.t("date.formats.default"))
      @conference.from_date = @conference.days.first.date.strftime(I18n.t("date.formats.default"))
      @one_day = (@conference.days.first == @conference.days.last)
    end

    def load_data
      @template_types = EmailTemplateType.all
      @email_templates = @conference.present? ? @conference.email_templates : []
      @template_hash = {}
      @email_templates.each { |et| @template_hash[et.email_template_type.type_name] ||= et }
    end

    def check_slug_params
      params.permit(:slug)
    end

    def set_conference
      @conference = Conference.friendly.find(params[:id])

      if @conference.days.first == @conference.days.last
        @conference.start_time = @conference.slots.first.start_time.strftime("%H:%M")
        @conference.end_time = @conference.slots.first.end_time.strftime("%H:%M")
      end
    end

    def sync_wizard_params
      params.require(:conference_wizard).permit(:id, :data)
    end

    def conference_params
      params.require(:conference).permit(:from_date, :to_date,
                                         :start_time, :end_time, :name, :slug,
                                         :summary, :description, :website, :twitter,
                                         :facebook, :email, :phone,
                                         organization_ids: [],
                                         settings: [
                                             :application_module,
                                             :sponsors_module,
                                             :speakers_module,
                                             :map_module,
                                             :organizators_module,
                                             :schedule_module,
                                         ],
                                         address_attributes: [:info, :city, :lat, :lon],
                                         appeal_types_attributes: [:id, :type_name, :_destroy],
                                         sponsors_attributes: [:id, :name, :website, :logo, :_destroy],
                                         email_templates_attributes: [:id, :subject, :body, :email_template_type_id]

      )
    end
end
