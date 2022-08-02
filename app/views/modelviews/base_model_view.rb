class BaseModelView
    protected
        def render_images(model)
            model.images.map { |image| {id: image.id, url: url_for(image), position: image.position} }
        end
end