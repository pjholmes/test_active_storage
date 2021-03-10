# Notes

1.
    ```
    > rails -v
    Rails 6.1.3

    > rails new test_active_storage -d postgresql -T
    > cd test_active_storage
    > rails active_storage:install
    > rails g scaffold Post title body:text
    > rails db:create
    > rails db:migrate
    ```

2. Edit `/config/storage.yml`

    ```
    public:
      service: Disk
      root: <%= Rails.root.join("tmp/storage/public") %>
      public: true

    private:
      service: Disk
      root: <%= Rails.root.join("tmp/storage/private") %>
    ```

3. Edit `/app/models/post.rb`

    ```
    class Post < ApplicationRecord
        has_one_attached :public_image, service: :public
        has_one_attached :private_image, service: :private
    end
    ```

4. Edit `/config/environments/development` to comment out default storage service

    ```
      # Store uploaded files on the local file system (see config/storage.yml for options).
      # config.active_storage.service = :local
    ```

5. Add the following to `/app/views/posts/_form.html.erb`

    ```
    <div class="field">
        <%= form.label :public_image %>
        <%= form.file_field :public_image %>
      </div>

      <div class="field">
        <%= form.label :private_image %>
        <%= form.file_field :private_image %>
      </div>
    ```

6. Add the following to `app/views/posts/show.html.erb`

    ```
    <div>Public Image:</div>
    <%= image_tag @post.public_image %>

    <div>Private Image:</div>
    <%= image_tag @post.private_image %>
    ```

7. Create some records in the UI and display them. Works fine.

8. Change `/app/views/posts/_form.html.erb` to add direct upload:

    ```
      <div class="field">
        <%= form.label :public_image %>
        <%= form.file_field :public_image, direct_upload: true %>
      </div>

      <div class="field">
        <%= form.label :private_image %>
        <%= form.file_field :private_image, direct_upload: true %>
      </div>
    ```

9. Try to add a Post. Results in 500.

    ```
    Started POST "/rails/active_storage/direct_uploads" for ::1 at 2021-03-09 13:02:57 -0800
    Processing by ActiveStorage::DirectUploadsController#create as JSON
      Parameters: {"blob"=>{"filename"=>"banana.jpg", "content_type"=>"image/jpeg", "byte_size"=>577085, "checksum"=>"W/vo/JqBNmJHMCaL+PRlBQ=="}, "direct_upload"=>{"blob"=>{"filename"=>"banana.jpg", "content_type"=>"image/jpeg", "byte_size"=>577085, "checksum"=>"W/vo/JqBNmJHMCaL+PRlBQ=="}}}
    Completed 500 Internal Server Error in 12ms (ActiveRecord: 3.3ms | Allocations: 5864)


      
    NoMethodError (undefined method `name' for nil:NilClass):
      
    activestorage (6.1.3) app/models/active_storage/blob.rb:52:in `block in <class:Blob>'
    activesupport (6.1.3) lib/active_support/callbacks.rb:427:in `instance_exec'
    activesupport (6.1.3) lib/active_support/callbacks.rb:427:in `block in make_lambda'
    activesupport (6.1.3) lib/active_support/callbacks.rb:235:in `block in halting_and_conditional'
    activesupport (6.1.3) lib/active_support/callbacks.rb:516:in `block in invoke_after'
    activesupport (6.1.3) lib/active_support/callbacks.rb:516:in `each'
    activesupport (6.1.3) lib/active_support/callbacks.rb:516:in `invoke_after'
    activesupport (6.1.3) lib/active_support/callbacks.rb:107:in `run_callbacks'
    activesupport (6.1.3) lib/active_support/callbacks.rb:824:in `_run_initialize_callbacks'
    activerecord (6.1.3) lib/active_record/core.rb:499:in `initialize'
    activerecord (6.1.3) lib/active_record/inheritance.rb:72:in `new'
    activerecord (6.1.3) lib/active_record/inheritance.rb:72:in `new'
    activerecord (6.1.3) lib/active_record/persistence.rb:54:in `create!'
    activestorage (6.1.3) app/models/active_storage/blob.rb:127:in `create_before_direct_upload!'
    activestorage (6.1.3) app/controllers/active_storage/direct_uploads_controller.rb:8:in `create'
    actionpack (6.1.3) lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'
    actionpack (6.1.3) lib/abstract_controller/base.rb:228:in `process_action'
    actionpack (6.1.3) lib/action_controller/metal/rendering.rb:30:in `process_action'
    actionpack (6.1.3) lib/abstract_controller/callbacks.rb:42:in `block in process_action'
    activesupport (6.1.3) lib/active_support/callbacks.rb:117:in `block in run_callbacks'
    actiontext (6.1.3) lib/action_text/rendering.rb:20:in `with_renderer'
    actiontext (6.1.3) lib/action_text/engine.rb:55:in `block (4 levels) in <class:Engine>'
    activesupport (6.1.3) lib/active_support/callbacks.rb:126:in `instance_exec'
    activesupport (6.1.3) lib/active_support/callbacks.rb:126:in `block in run_callbacks'
    activesupport (6.1.3) lib/active_support/callbacks.rb:137:in `run_callbacks'
    actionpack (6.1.3) lib/abstract_controller/callbacks.rb:41:in `process_action'
    actionpack (6.1.3) lib/action_controller/metal/rescue.rb:22:in `process_action'
    actionpack (6.1.3) lib/action_controller/metal/instrumentation.rb:34:in `block in process_action'
    activesupport (6.1.3) lib/active_support/notifications.rb:203:in `block in instrument'
    activesupport (6.1.3) lib/active_support/notifications/instrumenter.rb:24:in `instrument'
    activesupport (6.1.3) lib/active_support/notifications.rb:203:in `instrument'
    actionpack (6.1.3) lib/action_controller/metal/instrumentation.rb:33:in `process_action'
    actionpack (6.1.3) lib/action_controller/metal/params_wrapper.rb:249:in `process_action'
    activerecord (6.1.3) lib/active_record/railties/controller_runtime.rb:27:in `process_action'
    actionpack (6.1.3) lib/abstract_controller/base.rb:165:in `process'
    actionview (6.1.3) lib/action_view/rendering.rb:39:in `process'
    actionpack (6.1.3) lib/action_controller/metal.rb:190:in `dispatch'
    actionpack (6.1.3) lib/action_controller/metal.rb:254:in `dispatch'
    actionpack (6.1.3) lib/action_dispatch/routing/route_set.rb:50:in `dispatch'
    actionpack (6.1.3) lib/action_dispatch/routing/route_set.rb:33:in `serve'
    actionpack (6.1.3) lib/action_dispatch/journey/router.rb:50:in `block in serve'
    actionpack (6.1.3) lib/action_dispatch/journey/router.rb:32:in `each'
    actionpack (6.1.3) lib/action_dispatch/journey/router.rb:32:in `serve'
    actionpack (6.1.3) lib/action_dispatch/routing/route_set.rb:842:in `call'
    rack (2.2.3) lib/rack/tempfile_reaper.rb:15:in `call'
    rack (2.2.3) lib/rack/etag.rb:27:in `call'
    rack (2.2.3) lib/rack/conditional_get.rb:40:in `call'
    rack (2.2.3) lib/rack/head.rb:12:in `call'
    actionpack (6.1.3) lib/action_dispatch/http/permissions_policy.rb:22:in `call'
    actionpack (6.1.3) lib/action_dispatch/http/content_security_policy.rb:18:in `call'
    rack (2.2.3) lib/rack/session/abstract/id.rb:266:in `context'
    rack (2.2.3) lib/rack/session/abstract/id.rb:260:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/cookies.rb:689:in `call'
    activerecord (6.1.3) lib/active_record/migration.rb:601:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/callbacks.rb:27:in `block in call'
    activesupport (6.1.3) lib/active_support/callbacks.rb:98:in `run_callbacks'
    actionpack (6.1.3) lib/action_dispatch/middleware/callbacks.rb:26:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/executor.rb:14:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/actionable_exceptions.rb:18:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/debug_exceptions.rb:29:in `call'
    web-console (4.1.0) lib/web_console/middleware.rb:132:in `call_app'
    web-console (4.1.0) lib/web_console/middleware.rb:28:in `block in call'
    web-console (4.1.0) lib/web_console/middleware.rb:17:in `catch'
    web-console (4.1.0) lib/web_console/middleware.rb:17:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/show_exceptions.rb:33:in `call'
    railties (6.1.3) lib/rails/rack/logger.rb:37:in `call_app'
    railties (6.1.3) lib/rails/rack/logger.rb:26:in `block in call'
    activesupport (6.1.3) lib/active_support/tagged_logging.rb:99:in `block in tagged'
    activesupport (6.1.3) lib/active_support/tagged_logging.rb:37:in `tagged'
    activesupport (6.1.3) lib/active_support/tagged_logging.rb:99:in `tagged'
    railties (6.1.3) lib/rails/rack/logger.rb:26:in `call'
    sprockets-rails (3.2.2) lib/sprockets/rails/quiet_assets.rb:13:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/remote_ip.rb:81:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/request_id.rb:26:in `call'
    rack (2.2.3) lib/rack/method_override.rb:24:in `call'
    rack (2.2.3) lib/rack/runtime.rb:22:in `call'
    activesupport (6.1.3) lib/active_support/cache/strategy/local_cache_middleware.rb:29:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/executor.rb:14:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/static.rb:24:in `call'
    rack (2.2.3) lib/rack/sendfile.rb:110:in `call'
    actionpack (6.1.3) lib/action_dispatch/middleware/host_authorization.rb:98:in `call'
    rack-mini-profiler (2.3.1) lib/mini_profiler/profiler.rb:373:in `call'
    webpacker (5.2.1) lib/webpacker/dev_server_proxy.rb:25:in `perform_request'
    rack-proxy (0.6.5) lib/rack/proxy.rb:57:in `call'
    railties (6.1.3) lib/rails/engine.rb:539:in `call'
    puma (5.2.2) lib/puma/configuration.rb:248:in `call'
    puma (5.2.2) lib/puma/request.rb:76:in `block in handle_request'
    puma (5.2.2) lib/puma/thread_pool.rb:337:in `with_force_shutdown'
    puma (5.2.2) lib/puma/request.rb:75:in `handle_request'
    puma (5.2.2) lib/puma/server.rb:431:in `process_client'
    puma (5.2.2) lib/puma/thread_pool.rb:145:in `block in spawn_thread'
    ```

10. Changed `config/development.rb` to set a default storage service of `public`

    ```
    config.active_storage.service = :public
    ```

11. Restarted Rails and ran the test again. This time there was no 500, but both images were stored in the `public` store (in the `active_storage_blobs` table and on the file system).  In other words, the `service: :private` appears to have been ignored in my model:

    ```
    has_one_attached :private_image, service: :private
    ```

12. Tried changing the default to :private

    ```
    config.active_storage.service = :private
    ```

13.  Restarted Rails and ran the test again. This time both attachments used the `private` service (again, both in the `active_storage_blobs` table as well as the file system). Again, the service name in the model appears to have been ignored.

14. Commented out the default again to demonstrate the 500 error

    ```
    # Store uploaded files on the private file system (see config/storage.yml for options).
    # config.active_storage.service = :private
    ```

