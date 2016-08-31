class ConsolidatorController < ApplicationController
  require 'csv'

  def file_upload
  end

  def parser
    binding.pry
    Parser.parse(params[:file])
    redirect_to output path
  end

  def output_page
  end

end
