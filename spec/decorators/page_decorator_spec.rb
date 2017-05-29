require 'rails_helper'

RSpec.describe PageDecorator do
  before { @creator = create :user }

  [:lead, :content, :notes].each do |field|
    describe "##{field}_with_references" do
      context 'replacing page references' do
        before { @page_decorator = create(:page, creator: @creator).decorate }

        it 'converts @references to page ids to full page paths (e.g. @page-123)' do
          @page_decorator.update_attribute field, "[](@page-#{@page_decorator.id})"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Page test title](/en/pages/#{@page_decorator.id})"
        end

        it "doesn't take into account references that miss the @ (e.g. page-123)" do
          @page_decorator.update_attribute field, "[](page-#{@page_decorator.id})"
          expect(@page_decorator.send("#{field}_with_references")).to eq @page_decorator.send(field)
        end

        it "fails gracefully if page id doesn't exist" do
          @page_decorator.update_attribute field, "[Some alt](@page-123)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Some alt](@page-123)"
        end

        it 'replaces empty alt text with the page title' do
          @page_decorator.update_attribute field, "[](@page-#{@page_decorator.id})"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Page test title](/en/pages/#{@page_decorator.id})"
        end

        context 'alt text different to page title' do
          it 'adds the page title as title attribute' do
            @page_decorator.update_attribute field, "[some other title](@page-#{@page_decorator.id})"
            expect(@page_decorator.send("#{field}_with_references")).to eq "[some other title](/en/pages/#{@page_decorator.id}){title=\"Page test title\"}"
          end
        end

        context 'alt text equals page title' do
          it "doesn't add title as title attribute" do
            @page_decorator.update_attribute field, "[Page test title](@page-#{@page_decorator.id})"
            expect(@page_decorator.send("#{field}_with_references")).to eq "[Page test title](/en/pages/#{@page_decorator.id})"
          end
        end
      end

      context 'replacing image references' do
        before { @page_decorator = create(:page, creator: @creator, images: [create(:image, creator: @creator)]).decorate }

        it 'converts @references to image identifiers to full image paths (e.g. @image-test-123)' do
          @page_decorator.update_attribute field, "![My image](@image-Image test identifier)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "![My image](/uploads/image/file/#{@page_decorator.images.first.id}/image.jpg)"
        end

        it "doesn't take into account references that miss the @ (e.g. image-test-123)" do
          @page_decorator.update_attribute field, "[](image-Image test identifier)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[](image-Image test identifier)"
        end

        it "fails gracefully if image identifier doesn't exist" do
          @page_decorator.update_attribute field, "[Some alt](@image-inexistant)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Some alt](@image-inexistant)"
        end

        it "only replaces identifiers of own images" do
          other_page = create :page, title: 'Other page', creator: @creator, images: [create(:image, identifier: 'other-identifier', creator: @creator)]

          @page_decorator.update_attribute field, "![My image](@image-other-identifier)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "![My image](@image-other-identifier)"
        end
      end
    end
  end
end