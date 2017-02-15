module DummyFileHelper
  def dummy_file_path(file)
    File.expand_path("spec/support/dummy_files/#{file}")
  end

  def base64_image
    { data: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAASCAYAAACEnoQPAAAB6UlEQVQ4T4WTv8tBYRTHv9dvq7IwSJGUFGUli4FB+SMMkkEsRhaL8iOrLEiR0UgWViZKVhkUSnT9ejvP23PlfcOpW/e5z/2e83m+5zyCKIoPfAm5XA6ZTIbr9YrH4/m78E1Mws1mg2azCb/fD5fLxZJQfBRTtcPhgFQqheVyiVqtBrPZjNvt9l2sVCrR6XSQy+UQi8UQjUalqv8qC4IAhUIhZSbkwWCA/X6PUCgE2qdvFIQuYdPG5XJBv9/HZDKBWq2G3W6HxWLBdrvFeDzGer1m2JFIBFar9Smm85VKJbRaLeYsBTmrUqlYUgr6fj6f4XA4UKlUfsWEOpvNkEgkGA4X8wRExd9pL51OIxgM/orJmHq9jmq1Co1G87brROB2u1Eul59ukzifz6PX6zHMdyGKIsLhMDKZDDuKVLlQKKDdbjOj3gUJPB4PisUi80MSd7tdVv0TNgnIn2w2C6/X+zRssVggHo/jdDq9GPaXgqZLp9OxoXnpM51lOBx+RKfq9FB1SUw40+kUyWSS9ZImiX663+9ssnj7iCwQCLyKCY8SNBoN1jLqt1arhV6vZ0ehKSNkm83GvDEaja+3ig/DaDTCarWC0+mEyWTC8XjEfD7HbreDz+eDwWB4nW1uDL8cfM2xeWJa8yv5AylMJk+lIuNzAAAAAElFTkSuQmCC',
      size: 546
    }
  end

  def base64_other_image
    { data: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAAMCAYAAAC0qUeeAAABRklEQVQoU52Qv8tBYRTHPxf5mXIHiXJ178ZisniNtjv5Ayx+bP4jk8miyGAzKAPKX2CRWVJCca/n7Tnqzm/vqdPT6fn+OsdwHEfxxzL+Df58Pvi+H/iEw2FCoVAwB8oalMlksCyLaDTK6/XidDpxvV7RJF0C1orlchnXdUkmkwKMxWLc73dmsxmHw0EIhm3bKpFI0O/3eT6fTKdTbrcbuVyOVquF53kMh0MRMEqlksrn8/R6PdbrNYvFgng8jvf2qP/UqdVqjMdjcRFl/dntdkmn0+x2O7G9XC4C0AsqpUQgyFwsFmk2mxQKBVnw8XhwPB7ZbDbyplKpL1gzdbZIJEI2m5XWV6lWq6I8Go04n8/fzLZt02g0mM/ncipN1u04Dp1Oh+VyyXa7xbAsS1UqFdrtNpPJhP1+Lw76nKZpMhgMWK1WEucXCIOeJiM9wVEAAAAASUVORK5CYII=',
      size: 383
    }
  end
end

RSpec.configure do |config|
  config.include DummyFileHelper
end

FactoryGirl::SyntaxRunner.send(:include, DummyFileHelper)
