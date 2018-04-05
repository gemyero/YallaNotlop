Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # list certain group users
  get 'groups/:id/users', to: 'user#list_group_users'

  # add new group to certain user
  post 'users/:id/groups', to: 'group#add_group'

  #add order to certain user
  post 'users/:id/orders', to: 'order#add_order'

  # add user to group
  # post 'groups/:id/users', to: 'user#add_user_to_group'
  
end
