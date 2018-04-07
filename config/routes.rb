Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # list certain group users
  get 'users/:uid/groups/:gid/users', to: 'user#list_group_users'

  # add new group to certain user
  # body of request -> name
  post 'users/:uid/groups', to: 'group#add_group'

  #add order to certain user
  post 'users/:id/orders', to: 'order#add_order'

  # add friend to group
  # body of request -> name
  post 'users/:uid/groups/:gid/friends', to: 'user#add_friend_to_group'

  # add friend to user's friend list
  # body of request -> email
  post 'users/:uid/friends', to: 'user#add_friend_to_friend_list'

  # delete order 
  delete 'users/:id/orders/:oid', to: 'order#delete_order'
  
  # delete certain user group
  delete 'users/:uid/groups/:gid', to: 'group#delete_group'

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

  # add new user
  post 'users', to: 'user#register'

  # get all notifications for a user
  get 'users/:id/notifications', to: 'notification#get_all_notifications'

  # login user
  post 'users/login', to: 'user#login'

  # join order notification
  post 'users/:id/notifications', to: 'notification#join_order'

end
