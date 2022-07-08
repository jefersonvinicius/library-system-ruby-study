class BaseController < ApplicationController
  
  PER_PAGE = 5
  
  def make_meta(total_records:)
    @total_pages = (total_records / PER_PAGE).ceil + 1
    return {
      first_page: [0, 1].include?(current_page),
      last_page: current_page >= @total_pages,
      total_pages: @total_pages,
      page: current_page,
      total_records: total_records,
      per_page: PER_PAGE
    }
  end

  def current_page
    params.fetch(:page, 1).to_i
  end

  def offset
    (current_page - 1) * PER_PAGE
  end

  def render_not_found(args = nil)
    data = args.nil? ? nil : args.map{ |k,v| "#{k} = #{v}"}.join(", ")
    message = data.nil? ? "Model not found" : "Not found author with #{data}" 
    render json: {message: message}, status: :not_found
  end
end