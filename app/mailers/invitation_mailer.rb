class InvitationMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invite.subject
  #
  def invite_email(invitation)
    @organization = Organization.find(invitation.organization_id)
    @token = invitation.token

    mail to: "to@example.org"
  end
end
