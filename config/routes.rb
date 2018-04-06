Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # list certain group users
  get 'groups/:id/users', to: 'user#list_group_users'

  # add new group to certain user
  post 'users/:id/groups', to: 'group#add_group'

  #add order to certain user
  post 'users/:id/orders', to: 'order#add_order'

  # add friend to group
  post 'groups/:id/users/:uid/friends', to: 'user#add_friend_to_group'

  # add friend to user's friend list
  post 'users/:id/friends', to: 'user#add_friend_to_friend_list'

  # delete order 
  delete 'users/:id/orders/:oid', to: 'order#delete_order'
  
  # delete certain user group
  delete 'users/:id/groups/:gid', to: 'group#delete_group'

  # change state from waiting to finished
  patch 'users/:id/orders/:oid', to: 'order#change_state'

  # delete friend from group of user
  delete 'users/:uid/groups/:gid/friends/:fid', to: 'user#delete_friend_from_group'

  # delete friend from user's friend list
  delete 'users/:uid/friends/:fid', to: 'user#delete_friend_from_friend_list'

  # add order detail after user accept join request
  post 'users/:id/order_details', to: 'order_detail#add_order_details'

  # delete order detail for a certain user (oid : order detail id)
  delete 'users/:id/order_details/:oid', to: 'order_detail#delete_order_details'

  
end
