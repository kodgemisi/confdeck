module TemplateMailer

  def prepare(conference, type, vars = {}, subject_vars = {})
    template = conference.email_templates.joins(:email_template_type).where("email_template_types.type_name" => type).first

    if template.present? #if conference has custom email
      body_liquid = Liquid::Template.parse(template.body)
      subject_liquid = Liquid::Template.parse(template.subject)
    else #load default from EmailTemplateType
      template_type = EmailTemplateType.find_by type_name: type
      body_liquid = Liquid::Template.parse(template_type.default_body)
      subject_liquid = Liquid::Template.parse(template_type.default_subject)
    end

    body = body_liquid.render(vars)

    if subject_vars.present?
      subject = subject_liquid.render(subject_vars)
    else
      subject = subject_liquid.render(vars)
    end

    LiquidEmail.new(body, subject)
  end

  class LiquidEmail
    attr_accessor :body
    attr_accessor :subject

    def initialize(body, subject)
      @body = body
      @subject = subject
    end
  end
end