class Sorting
    def self.sort(models:, changing:, to:)
        return if to > models.length || to < 0
        target_model = models[to]
        changing_model = models.find { |model| model.id == changing.id }
        new_target_index = changing_model.position
        target_model.position = new_target_index;
        changing_model.position = to
        return [changing_model, target_model]
    end
end