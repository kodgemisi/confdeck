class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  def accept
    @token = params[:invitation_token]

    respond_to do |format|
      if Invitation.accept_invitation(@token, current_user)
        format.html { redirect_to organizations_path, notice: 'You are now member of the organization.' }
      else
        format.html { redirect_to root_url, notice: 'Your invitation token is wrong.' }
      end
    end
  end
end
