module Admin::AssetsHelper

  def accepted_content_types
    raw Asset::ACCEPTED_CONTENT_TYPES.to_json
  end

end
