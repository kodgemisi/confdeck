class InvitationMailer < ActionMailer::Base
  default from: "confmanrumble@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invite.subject
  #
  def invite_email(invitation)
    @organization = Organization.find(invitation.organization_id)
    @token = invitation.token

    mail to: invitation.email, subject: "New invitation for ConfMan organization"
  end
end
