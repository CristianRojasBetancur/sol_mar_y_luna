class ErrorSerializer
  def self.serialize(errors)
    {
      errors: errors.each_with_index.map do |error, index|
        error_info = build_error_info(error)

        {
          message: error_info[:message],
          code: error_info[:code],
          index: index
        }
      end
    }
  end

  private

  def self.build_error_info(error)
    translated_details = translate_details(error.details)

    {
      message: I18n.t("errors.#{error.url}.message", **translated_details, default: error.url),
      code: I18n.t("errors.#{error.url}.code")
    }
  end

  def self.translate_details(details)
    resource = details.fetch(:resource)
    return details unless resource

    translated_resource = I18n.t("activerecord.models.#{resource.downcase}.one")
    article = I18n::Gender.article_for(resource.constantize)

    details.merge(resource: translated_resource, article: article)
  end
end
