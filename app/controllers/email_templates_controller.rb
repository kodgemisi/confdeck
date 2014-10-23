class EmailTemplatesController < ApplicationController
  before_filter :authenticate_user!

  before_filter :set_conference

  before_filter :authorize_user


  def index
    @template_types = EmailTemplateType.all
    @email_templates = @conference.email_templates
    @template_hash = {}
    @email_templates.each { |et| @template_hash[et.email_template_type.type_name] ||= et }

  end

  private
  def set_conference
    @conference = Conference.friendly.find(params[:conference_id])
  end

  def authorize_user
    unless @conference.users.include? current_user
      redirect_to root_url, notice: "You shall not pass"
    end
  end
end
