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
  include Activitable
  before_action :set_conference, only: [:show, :apply, :save_apply]
  before_action :load_data, only: [:new, :edit, :update]
  layout 'conference_landing', only: [:show, :apply, :save_apply]

  def new
    authorize Conference

    @wizard = current_user.conference_wizard

    if @wizard.present?
      conf_params = Rack::Utils.parse_nested_query @wizard.data
      @conference = Conference.new(conf_params["conference"])
      @conference.build_address if @conference.address.nil?
      @conference.speech_types.build if @conference.speech_types.empty?
      #@conference.sponsors.build if @conference.sponsors.nil?
    else
      @conference = Conference.new
      @conference.build_address
      @conference.speech_types.build
      #@conference.sponsors.build
      @wizard = current_user.build_conference_wizard
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  # POST /conferences
  # POST /conferences.json
  def create
    authorize Conference

    @conference = Conferences::CreateConferenceService.instance.call(conference_params, current_user)

    if @conference.persisted? && @conference.errors.empty?
      redirect_to admin_conference_url(subdomain: @conference.slug) , notice: 'Conference was successfully created.'
    else
      load_data
      render action: "new"
    end
  end

  # GET /conferences/1
  # GET /conferences/1.json
  def show
    @one_day = (@conference.days.first == @conference.days.last)
    @days = @conference.days
    @slots = @conference.slots.group_by(&:day)

    @data = {}

    # To fix error on the slot for one day conferences
    unless @conference.rooms.empty?
      @days.each do |day|
        @data[day.date] = day.slots.group_by(&:room)
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  def apply
    @speech = @conference.speeches.new
    @speech.build_topic
  end

  #TODO must be reviewed
  def save_apply
    @speech = Speech.new(speech_params)
    @speech.conference = @conference
    respond_to do |format|
      if @speech.save
        @conference.touch #cache invalidation
        create_activity!(nil, @conference, @speech, "speech_new")
        format.html { redirect_to apply_conference_path, notice: t("general.application_received", topic: @speech.topic.subject) }
      else
        format.html { render action: "apply" }
      end
    end
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

    redirect_to new_conferences_path
  end

  private

    def check_slug_params
      params.permit(:slug)
    end

    def sync_wizard_params
      params.require(:conference_wizard).permit(:id, :data)
    end

    def speech_params
      params.require(:speech).permit(:speech_type_id, topic_attributes: [:subject, :abstract, :detail, :additional_info, speaker_ids: []])
    end

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

    def set_conference
      @conference = Conference.friendly.find(request.subdomain)

      if @conference.days.first == @conference.days.last
        @conference.start_time = @conference.slots.first.start_time.strftime("%H:%M")
        @conference.end_time = @conference.slots.first.end_time.strftime("%H:%M")
      end
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
                                         speech_types_attributes: [:id, :type_name, :_destroy],
                                         sponsors_attributes: [:id, :name, :website, :logo, :_destroy],
                                         email_templates_attributes: [:id, :subject, :body, :email_template_type_id]

      )
    end
end
