# See https://github.com/glebm/i18n-tasks/issues/183

require 'rails_helper'
require 'i18n/tasks'

describe 'I18n' do
  it 'does not have missing model attribute translations' do
    I18n.backend.send(:init_translations)
    fail_message = ''
    options = YAML.load_file(Rails.root.to_s + '/config/i18n-tasks.yml')

    I18n.available_locales.each do |locale|
      I18n.locale = locale

      project_models.each do |model|
        missing_columns = []
        model_attributes_to_ignore = options['ignore_models']['attributes'][model.name.underscore] || []

        model.column_names.reject do |column_name|
          column_name =~ /^id$|_id$/
        end.each do |column_name|
          begin
            I18n.t "activerecord.attributes.#{model.name.underscore}.#{column_name}", raise: true
          rescue I18n::MissingTranslationData => exception
            missing_columns << column_name unless model_attributes_to_ignore.include? column_name
          end
        end

        fail_message += "- #{model.name} (#{locale}): " + missing_columns.join(', ') + "\n" if missing_columns.any?
      end
    end

    fail "Missing model attribute translations:\n#{fail_message}" unless fail_message.empty?
  end

  it 'does not have missing model name translations' do
    I18n.backend.send(:init_translations)
    fail_message = ''
    model_names_to_ignore = YAML.load_file(Rails.root.to_s + '/config/i18n-tasks.yml')['ignore_models']['names']

    I18n.available_locales.each do |locale|
      project_models.each do |model|
        model_key = "activerecord.models.#{model.name.underscore.to_sym}"

        begin
          I18n.backend.send(:translations)[locale][:activerecord][:models][model.name.underscore.to_sym][:one]
        rescue NoMethodError
          fail_message += "- #{model.name} (#{locale}): #{model_key}.one\n" unless model_names_to_ignore.include? model.name.underscore
        end

        begin
          I18n.backend.send(:translations)[locale][:activerecord][:models][model.name.underscore.to_sym][:other]
        rescue NoMethodError
          fail_message += "- #{model.name} (#{locale}): #{model_key}.other\n" unless model_names_to_ignore.include? model.name.underscore
        end
      end
    end

    fail "Missing model name translations:\n#{fail_message}" unless fail_message.empty?
  end

  def project_models
    @project_models ||= ::ActiveRecord::Base.subclasses.collect { |type| type.name }.reject { |descendant| descendant =~ /^HABTM_|ActiveRecord|PaperTrail|ApplicationRecord/ }.sort.map { |descendant| descendant.constantize }
  end
end
