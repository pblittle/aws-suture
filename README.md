Suture
======

Suture is a tool for scanning your AWS EC2 instances for Heartbleed vulnerability.

## Building and scanning

You'll need to start by exporting your AWS credentials:

```
$ export AWS_ACCESS_KEY_ID='your-access-key'
$ export AWS_SECRET_ACCESS_KEY='your-secret-key'
```

Next, begin scanning your instances by running the following commands:

```
$ bundle install
$ ./bin/suture check
```

## License

This application is distributed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
