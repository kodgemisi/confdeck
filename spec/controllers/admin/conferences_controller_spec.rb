require 'rails_helper'

RSpec.describe Admin::ConferencesController do
  # Create valid attributes for post
  def valid_attributes
    {
        from_date: "07/01/2015",
        to_date: "10/02/2015",
        name: "Best Conference",
        summary: "Facere voluptatem et ut voluptas",
        description: "Sapiente et modi molestias. Nemo dolore possimus doloribus. Sint quas delectus nihil debitis blanditiis dolor reprehenderit.",
        email: "selam@dedeler.com",
        organization_ids: [Fabricate(:organization).id],
        speech_types_attributes: {
            '0' => {type_name: "Workshop"}
        }
    }
  end

  before :all do
    @user = Fabricate(:user)
  end

  before :each do
    sign_in @user
  end

end