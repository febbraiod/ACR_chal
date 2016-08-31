Rails.application.routes.draw do
 
  root to: 'consolidator#file_upload'

  post '/parser' => 'consolidator#parser'
end
