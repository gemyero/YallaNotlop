Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # list certain group users
  get 'groups/:id/users', to: 'user#list_group_users'

  # add new group to certain user
  post 'users/:id/groups', to: 'group#add_group'

  # add friend to group
  post 'groups/:id/users/:uid/friends', to: 'user#add_friend_to_group'

  # add friend to user's friend list
  post 'users/:id/friends', to: 'user#add_friend_to_friend_list'
  
end
