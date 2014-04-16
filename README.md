Suture
======

Suture is a tool for scanning your AWS EC2 instances for Heartbleed vulnerability. It will ssh into each of your EC2 instances, run `openssl version -b` to check the openssl build date. If the output of the command matches `Mon Apr  7 20:33:29 UTC 2014`, then we know the build does not include the Heartbleed vulnerability.

Without having the resources to test in environments outside of Ubuntu, I have made both the check and result configurable. Simply pass the check command using `--check-command` and the desired result using `--check-result`. A regex match will be performed to determine the result.

If you prefer to check only one instance, pass in the `--instance-id` flag with the instance ID in question. This will reduce the query to one instance.

## Usage

You'll need to start by giving suture your AWS credentials. You can either export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` credentials:

```
$ export AWS_ACCESS_KEY_ID='your-access-key'
$ export AWS_SECRET_ACCESS_KEY='your-secret-key'
```

Alternatively, you can use the command line flags `--aws-access-key` and `--aws-secret-access-key` to authenticate.

By default, suture uses the `ubuntu` user to connect to the instance. This can be changed by using the `--ssh-user` flag. The default private key path is `~/.ec2`. You can overwrite this path by using the `--identity-file-path` flag.

Finally, run the `check` command to view the status of your instances:

```
$ bundle install
$ bundle exec ./bin/suture [<options>] check
```

For additional command options, `./bin/suture --help`:

```
 Usage: suture [<options>] check
    -A, --aws-access-key-id KEY      the access key identifier
    -K SECRET,                       the access key identifier
        --aws-secret-access-key
    -x, --ssh-user USERNAME          the ssh username
    -i IDENTITY_FILE_PATH,           the SSH identity file used for authentication
        --identity-file-path
    -I, --instance-id INSTANCE_ID    the instance to check
    -c CHECK_COMMAND,                the check command to run
        --check-command
    -r, --check-result CHECK_RESULT  the check result to match
```

You will find the default config values in the options hash. You should overwrite these values using the command line flags.

```ruby
  options = {
    :aws => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :ec2 => {
        :ssh_user => 'ubuntu',
        :instance_id => nil,
        :identity_file_path => ::File.join(Dir.home, '.ec2')
      }
    },
    :check_command => 'openssl version -a',
    :check_result => 'Mon Apr  7 20:33:29 UTC 2014'
  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This application is distributed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
