require 'rails_helper'

describe ImageGalleryHelper do
  describe '#image_gallery' do
    it 'uses the name parameter (if available)' do
      expect(image_gallery('my_gallery') { |gallery| }).to have_css 'div.my_gallery'
    end

    it 'generates a name (if none passed as parameter)' do
      expect(image_gallery { |gallery| }).to have_css 'div[class^="gallery_"]'
    end
  end

  describe '#zoomable_image' do
    let(:image) do
      image = double
      expect(image).to receive(:url) { 'original-url' }
      expect(image).to receive(:url).with(:thumb) { 'thumb-url' }
      image
    end

    context 'called on its own' do
      subject { zoomable_image image, class: 'some_class', alt: 'This is a great image' }

      it { should     have_css 'a.fancybox img' }
      it { should     have_css 'a[href="original-url"]' }
      it { should_not have_css 'a[rel]' }
      it { should     have_css 'img.some_class' }
      it { should     have_css 'img[alt="This is a great image"]' }
      it { should     have_css 'img[src="/images/thumb-url"]' }
    end

    context 'called inside image_gallery' do
      subject do
        image_gallery 'my_gallery' do |gallery|
          gallery.zoomable_image image, class: 'some_class', alt: 'This is a great image'
        end
      end

      it { should have_css 'div.my_gallery a.fancybox img' }
      it { should have_css 'a[rel="my_gallery"]' }
    end
  end
end
