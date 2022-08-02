class TestsController < ApplicationController 
    def test
        attachment = ActiveStorage::Attachment.includes(:blob).where(id: params[:image_id]).first

        render json: {attachment: attachment, url: url_for(attachment)}
    end
end