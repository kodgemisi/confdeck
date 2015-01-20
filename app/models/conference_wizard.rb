class ConferenceWizard < ActiveRecord::Base
  belongs_to :user

  def self.new_with_name(name)

    # Generate a slug candidate
    slug = Conference.new(name: name).generate_slug_preview # TODO refactor

    default_hash = {
        "conference" => {
            "name" => name,
            "slug" => slug
        }
    }
    new(
        data: default_hash.to_query
    )
  end
end
