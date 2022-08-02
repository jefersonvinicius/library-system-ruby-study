class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.save_many(models)
    ActiveRecord::Base.transaction do  
      models.each { |model| model.save }  
    end
  end

  def attach_positioned(*attachable)
    self.images.attach(attachable)
    new_image = self.images.last
    new_image.position = self.images.length - 1
    new_image.save
  end

  def purge_positioned(image_purging)
    image_purging.purge
    biggest = self.images.select { |image| image.position > image_purging.position}
    biggest.each { |image| image.position -= 1 }
    self.class.save_many(biggest)
  end
end
