module I18n
  module Gender
    ARTICLES = {
      male:   { singular: "el", plural: "los" },
      female: { singular: "la", plural: "las" }
    }.freeze

    def self.article_for(model_class, count: 1)
      model_key = model_class.model_name.i18n_key
      gender = ::I18n.t("activerecord.models.#{model_key}.gender")

      number = count == 1 ? :singular : :plural
      ARTICLES.fetch(gender.to_sym).fetch(number)
    end
  end
end
