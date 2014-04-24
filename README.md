## tl;dr

```bash
$ git clone git@github.com:pblittle/suture.git
$ cd suture
$ bundle install
$ bundle exec ./bin/suture --help
$ bundle exec ./bin/suture <options> check
```

Suture
======

Suture is a tool for running arbitrary commands against your AWS EC2 instances. You can run it against an individual instance or an entire region. Suture was originally written to determine if any of our running EC2 instances were using a version of OpenSSL susceptible to the Heartbleed vulnerability.

A suture check will ssh into each of your EC2 instances and execute a given command. The output of the command will be compared to a provided string or regular expression for validation.

By default, Suture will run `openssl version -v` to check the OpenSSL version. If the output of the command matches `1.0.(1[a-f]|2-beta1)`, then we know the build does not include the Heartbleed vulnerability. A report will indicate the comparision result.

If you aren't using this for the OpenSSL vunlerability check, simply pass a custom check command using `--check-command` and the desired result using `--check-result`. A regex match will be performed to determine the result.

If you prefer to check only one instance, pass in the `--instance-id` flag with the instance ID in question. This will reduce the query to one instance.

If you are checking a region other than `us-east-1`, provide the desired region using the `--region` flag.

## Usage

You'll need to start by giving suture your AWS credentials. You can either export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` credentials:

```bash
$ export AWS_ACCESS_KEY_ID='your-access-key'
$ export AWS_SECRET_ACCESS_KEY='your-secret-key'
```

Alternatively, you can use the command line flags `--aws-access-key` and `--aws-secret-access-key` to authenticate.

By default, suture uses the `ubuntu` user to connect to the instance. This can be changed by using the `--ssh-user` flag. The default private key path is `~/.ec2`. You can overwrite this path by using the `--identity-file-path` flag.

Finally, run the `check` command to view the status of your instances:

```bash
$ bundle install
$ bundle exec ./bin/suture [<options>] check
```

For additional command options, `./bin/suture --help`:

```bash
 Usage: suture [<options>] check
    -A, --aws-access-key-id KEY      the access key identifier
    -K SECRET,                       the access key identifier
        --aws-secret-access-key
    -x, --ssh-user USERNAME          the ssh username
    -i IDENTITY_FILE_PATH,           the SSH identity file used for authentication
        --identity-file-path
    -I, --instance-id INSTANCE_ID    the instance to check
        --region REGION              your AWS region
    -c CHECK_COMMAND,                the check command to run
        --check-command
    -r, --check-result CHECK_RESULT  the check result to match
```

You will find the default config values in the options hash. You should overwrite these values using the command line flags above.

```ruby
  options = {
    :aws => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :ec2 => {
        :ssh_user => 'ubuntu',
        :instance_id => nil,
        :identity_file_path => ::File.join(Dir.home, '.ec2')
      },
      :region => 'us-east-1'
    },
    :check_command => 'openssl version -v',
    :check_result => 'OpenSSL 1.0.1g 7 Apr 2014'
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
