class BaseModelView
    protected
        def render_images(model)
            images = model.images.sort_by(&:position)
            images.map { |image| {id: image.id, url: url_for(image), position: image.position} }
        end
end