require 'rails_helper'

RSpec.describe PageDecorator do
  before { @creator = create :user }

  [:lead, :content, :notes].each do |field|
    describe "##{field}_with_references" do
      context 'replacing page references' do
        before { @page_decorator = create(:page, creator: @creator).decorate }

        it 'converts @references to page ids to full page paths (e.g. @page-123)' do
          @page_decorator.update_attribute field, "[](@page-#{@page_decorator.id})"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Page test title](/en/pages/#{@page_decorator.id}){.page}"
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
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Page test title](/en/pages/#{@page_decorator.id}){.page}"
        end

        context 'alt text different to page title' do
          it 'adds the page title as title attribute' do
            @page_decorator.update_attribute field, "[some other title](@page-#{@page_decorator.id})"
            expect(@page_decorator.send("#{field}_with_references")).to eq "[some other title](/en/pages/#{@page_decorator.id}){.page title=\"Page test title\"}"
          end
        end

        context 'alt text equals page title' do
          it "doesn't add title as title attribute" do
            @page_decorator.update_attribute field, "[Page test title](@page-#{@page_decorator.id})"
            expect(@page_decorator.send("#{field}_with_references")).to eq "[Page test title](/en/pages/#{@page_decorator.id}){.page}"
          end
        end
      end

      context 'replacing image references' do
        before { @page_decorator = create(:page, creator: @creator, images: [create(:image, creator: @creator)]).decorate }

        it 'converts @references to image identifiers to full image paths (e.g. @image-test-123)' do
          @page_decorator.update_attribute field, "![My image](@image-Image test identifier)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "![My image](/uploads/image/file/#{@page_decorator.images.first.id}/image.jpg){.image}"
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

      context 'replacing code references' do
        before { @page_decorator = create(:page, creator: @creator, codes: [create(:code, identifier: 'test-123', creator: @creator)]).decorate }

        it 'converts @references to code identifiers to full code paths (e.g. @code-test-123)' do
          @page_decorator.update_attribute field, "[My code](@code-test-123)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[**My code**![](Code test thumbnail url)](https://codepen.io/test/debug/123){.code title=\"Code test title\"}"
        end

        it "doesn't take into account references that miss the @ (e.g. code-test-123)" do
          @page_decorator.update_attribute field, "[](code-test-123)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[](code-test-123)"
        end

        it "fails gracefully if code identifier doesn't exist" do
          @page_decorator.update_attribute field, "[Some alt](@code-inexistant)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[Some alt](@code-inexistant)"
        end

        it "only replaces identifiers of own codes" do
          other_page = create :page, creator: @creator, title: 'Other page', codes: [create(:code, creator: @creator, identifier: 'other-identifier')]

          @page_decorator.update_attribute field, "[My code](@code-other-identifier)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[My code](@code-other-identifier)"
        end

        it 'replaces empty text with the code title' do
          @page_decorator.update_attribute field, "[](@code-test-123)"
          expect(@page_decorator.send("#{field}_with_references")).to eq "[**Code test title**![](Code test thumbnail url)](https://codepen.io/test/debug/123){.code}"
        end

        context 'text different to code title' do
          it 'adds the code title as title attribute' do
            @page_decorator.update_attribute field, "[some other title](@code-test-123)"
            expect(@page_decorator.send("#{field}_with_references")).to eq "[**some other title**![](Code test thumbnail url)](https://codepen.io/test/debug/123){.code title=\"Code test title\"}"
          end
        end

        context 'text equals code title' do
          it "doesn't add title as title attribute" do
            @page_decorator.update_attribute field, "[Code test title](@code-test-123)"
            expect(@page_decorator.send("#{field}_with_references")).to eq "[**Code test title**![](Code test thumbnail url)](https://codepen.io/test/debug/123){.code}"
          end
        end
      end
    end
  end
end