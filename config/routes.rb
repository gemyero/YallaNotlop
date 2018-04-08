Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # action cable server URI
  mount ActionCable.server => '/cable'

  # list certain group users
  get 'users/:uid/groups/:gid/users', to: 'user#list_group_users'

  # add new group to certain user
  # body of request -> name
  post 'users/:uid/groups', to: 'group#add_group'

  # add order to certain user
  # body -> state = waiting, order_for(breakfast, launch,...), friends[1, 2, ..](array of friends id), restaurant name, and menu_img
  post 'users/:uid/orders', to: 'order#add_order'

  # add friend to group
  # body of request -> name
  post 'users/:uid/groups/:gid/friends', to: 'user#add_friend_to_group'

  # add friend to user's friend list
  # body of request -> email
  post 'users/:uid/friends', to: 'user#add_friend_to_friend_list'

  # delete order 
  delete 'users/:uid/orders/:oid', to: 'order#delete_order'
  
  # delete certain user group
  delete 'users/:uid/groups/:gid', to: 'group#delete_group'

  # change state from waiting to finished
  patch 'users/:uid/orders/:oid', to: 'order#change_state'

  # delete friend from group of user
  delete 'users/:uid/groups/:gid/friends/:fid', to: 'user#delete_friend_from_group'

  # delete friend from user's friend list
  delete 'users/:uid/friends/:fid', to: 'user#delete_friend_from_friend_list'

  # add order detail after user accept join request
  # body -> order_id, item, amount, price, and comment
  post 'users/:uid/order_details', to: 'order_detail#add_order_details'

  # delete order detail for a certain user (oid : order detail id)
  delete 'users/:uid/order_details/:oid', to: 'order_detail#delete_order_details'

  # add new user
  # body -> name, email, password, provider in case FB and google only
  post 'users', to: 'user#register'

  # get all notifications for a user
  get 'users/:uid/notifications', to: 'notification#get_all_notifications'

  # login user
  # body -> email, password
  post 'users/login', to: 'user#login'

  # join order notification
  post 'users/:uid/notifications', to: 'notification#join_order'

  # view notification of user
  patch 'users/:uid/notifications', to: 'notification#view_notifications'

  # route to forget password
  # body -> email
  post 'password/forget', to: 'user#forget_password'

  # route to reset password
  # body -> password
  # query string -> token=
  post 'password/reset', to: 'user#reset_password'

  # list user orders with pagination
  # ex: users/1/orders?page=2&per_page=3
  get 'users/:uid/orders', to: 'order#list_user_orders'

  # list user friends with pagination
  # ex: users/1/friends?page=2&per_page=3
  get 'users/:uid/friends', to: 'user#list_user_friends'

  # list certain user groups
  get 'users/:uid/groups', to: 'group#list_user_groups'

  # login with facebook
  post 'users/login/facebook', to: 'user#login_facebook'

  # login with google
  post 'users/login/google', to: 'user#login_google'

  # get user data
  get 'users/:uid', to: 'user#fetch_user'

end
