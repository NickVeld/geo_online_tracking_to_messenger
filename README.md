# geo_online_tracking_to_messenger
Transfers geolocation online tracking ping to a messanger

## Supported external service

### Input ( Online tracker app )

- OSM And

### Output ( Messenger )

- Telegram

## How to use

### Prerequisites

It must work in most POSIX-compatible shells, even git-bash on Windows.

The only thing you need is `ncat`.

`ncat` is not meant for highloads so it is better
to run it only for local connections.

It is possible by doing the following steps:

[Android]
1. Download Termux from F-Droid or other source
2. In Termux run `pkg upgrade` and `pkg install nmap-ncat`
3. `tar` and `curl` is installed by default so you can download the latest code version by the following command

```commandline
curl -L https://github.com/NickVeld/geo_online_tracking_to_messenger/archive/main.tar.gz | tar xz
```

### Preparation

Enter the directory of the repository.

Create personal files from examples:

```commandline
cp FILENAME.example.EXT FILENAME.EXT 
```

Update the files with your information.

### Run the code

This command must work
```commandline
ncat --sh-exec "/usr/bin/env bash geo_online_tracking_to_messenger.sh" --keep-open -l localhost PORT_TO_LISTEN
```

BUT in one environment `ncat` with `--sh-exec` does not allow to read
into the communication between the client and `ncat`
because `ncat` catches all the output to send to the client.
Plus, `ncat` with `--sh-exec` polls all the ports and floods verbose output
(without `--sh-exec` everything is fine).
So as an alternative, the following command can be used
```commandline
PORT_TO_LISTEN=YOUR_PORT /usr/bin/env bash run_with_loop.sh
```

Start geolocation online tracking

## For developers

### Testing

In order to test the app ypu can use mocked version of `ncat` supplied in this repo.
Unfortunately, the communication with the external service cannot be tested,
see the mocked `ncat` definition.

Warning: leave --sh-exec ...sh in the start because
the mocked ncat does not parse args, just takes the 2nd arg.

```
PATH=.:${PATH} ncat --sh-exec geo_online_tracking_to_messenger.sh -l localhost YOUR_PORT
```
