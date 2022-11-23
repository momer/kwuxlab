# Nomad

## Install

Ref:
  - [Getting Started](https://learn.hashicorp.com/tutorials/nomad/get-started-install?in=nomad/get-started)

## Submit jobs

Ref: 
  - [Getting Started (Job)](https://learn.hashicorp.com/tutorials/nomad/get-started-learn-more?in=nomad/get-started)

1. SET `NOMAD_ADDR` environment variable to fully qualified URI of a nomad server.
```sh
export NOMAD_ADDR="http://tsnode1:4646"
```
1. SET `NOMAD_TOKEN` environment variable to the management token of choice.
```sh
export NOMAD_TOKEN="<REPLACE_WITH_SECRET_ID_UUID>"
```

## Clear old failed/dead jobs

```
nomad system reconcile summaries
```
